import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter_social_media/src/core/helpers/permission_helper.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/services/notification_services.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/features/Chat/presentation/about_profile.dart';
import 'package:flutter_social_media/src/features/Chat/presentation/call_screen_page.dart';
import 'package:flutter_social_media/src/features/Chat/domain/models/message_model.dart';
import 'package:flutter_social_media/src/features/Chat/infrastructure/chat_service.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/components/app_audio_player.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/screenshot_privacy.dart';

import 'package:uuid/uuid.dart';

import '../../auth/domain/models/user.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.name, required this.id, required this.imageUrl, required this.userId});
  static const route = 'chat_page';
  final String name;
  final String imageUrl;
  final String id;
  final String userId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FeedRepository _feedRepository = FeedRepository();

  late Userx? currentUser;

  ScreenshotPrivacy _screenshotPrivacy = ScreenshotPrivacy.allow;
  final _noScreenshot = NoScreenshot.instance;

  late String currentUserId;
  bool _isCurrentUserInitialized = false;

  List<MessageModel> _pendingMessages = []; // <--- ADD THIS LINE

  Future<void> _initializeCurrentUser() async {
    final user = await AuthRepository().getCurrentUserData();

    if (!mounted) return;

    if (user != null) {
      setState(() {
        currentUser = user;
        currentUserId = user.uuid;
        _isCurrentUserInitialized = true;
      });
    }
  }

  // ===== MEDIA FILE (IMAGE/VIDEO) =====
  File? _mediaFile;
  String? _mediaType; // 'image' or 'video'
  bool _isSending = false;
  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    log('pickedFile: ${pickedFile}');

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _mediaType = pickedFile.mimeType?.startsWith('video') == true ? 'video' : 'image';

        // if (_mediaType == 'video') {
        //   _videoController?.dispose();
        //   _videoController = VideoPlayerController.file(_mediaFile!)
        //     ..initialize().then((_) {
        //       setState(() {});
        //       _videoController!.setLooping(true);
        //       _videoController!.play();
        //     });
        // }
      });
    }

    log('media picked: ${_mediaFile?.path}');
  }

  // ===== AUDIO RECORDING =====
  late AudioRecorder _audioRecorder;
  bool _isRecording = false;

  final Stopwatch _recordingStopwatch = Stopwatch();
  Future<void> _startRecording() async {
    log('_startRecording() called');
    // mic permission
    final status = await PermissionHelper().requestMicrophonePermission();

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Microphone permission is permanently denied.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return;
    } else if (!status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Microphone permission is required to record audio.')));
      return;
    }

    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/audio_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

      _recordingStopwatch.reset();
      _recordingStopwatch.start();
      await _audioRecorder.start(const RecordConfig(), path: path);

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      log("Failed to start recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingStopwatch.stop();
      final duration = _recordingStopwatch.elapsed;

      setState(() {
        _isRecording = false;
      });

      if (duration.inSeconds < 4) {
        AppSnackbar.show(context, message: 'Recording is too short.', backgroundColor: Colors.amber);
        if (path != null) {
          try {
            File(path).delete();
          } catch (e) {
            log("Failed to delete short audio file: $e");
          }
        }
        return;
      }

      if (path != null) {
        final audioFile = File(path);
        await _sendMessage(fileToSend: audioFile, mediaType: MessageType.audio.name);
      }
    } catch (e) {
      log("Failed to stop recording: $e");
    } finally {
      _recordingStopwatch.reset();
    }
  }

  // ===== SEND MESSAGE =====
  Future<void> _sendMessage({File? fileToSend, String? mediaType}) async {
    if (_isSending || (_controller.text.trim().isEmpty && fileToSend == null)) {
      return;
    }

    // temporary ID for the local display
    final String tempMessageId = const Uuid().v4();

    // Determine the type for the local message
    MessageType localMessageType;
    if (fileToSend != null && mediaType != null) {
      if (mediaType == 'image') {
        localMessageType = MessageType.image;
      } else if (mediaType == 'video') {
        localMessageType = MessageType.video;
      } else if (mediaType == 'audio') {
        localMessageType = MessageType.audio;
      } else {
        localMessageType = MessageType.text;
      }
    } else {
      localMessageType = MessageType.text;
    }

    // Create a MessageModel to display immediately
    final MessageModel localMessage = MessageModel(
      id: tempMessageId,
      senderId: currentUserId,
      content: _controller.text.trim(),
      mediaUrl: fileToSend?.path,
      type: localMessageType,
      timestamp: DateTime.now(),
      seenBy: [],
      reactions: {},
    );

    setState(() {
      _isSending = true;
      _pendingMessages.insert(0, localMessage);
      _controller.clear();
      _mediaFile = null;
      _mediaType = null;
    });

    try {
      List<String> mediaUrls = [];
      MessageType actualMessageType;

      if (fileToSend != null && mediaType != null) {
        // Convert File to XFile
        final XFile xFileToSend = XFile(fileToSend.path);
        mediaUrls = await _feedRepository.uploadPostAttachments(attachments: [xFileToSend], postId: 'chat_media');

        if (mediaType == 'image') {
          actualMessageType = MessageType.image;
        } else if (mediaType == 'video') {
          actualMessageType = MessageType.video;
        } else if (mediaType == 'audio') {
          actualMessageType = MessageType.audio;
        } else {
          actualMessageType = MessageType.text;
        }
      } else {
        actualMessageType = MessageType.text; // If no file, it's a text message
      }

      final text = localMessage.content;

      // Create the actual message to send to Firestore
      final newMessage = MessageModel(
        id: const Uuid().v4(),
        senderId: currentUserId,
        content: text,
        mediaUrl: mediaUrls.isEmpty ? null : mediaUrls.first,
        type: actualMessageType,
        timestamp: DateTime.now(),
        seenBy: [],
        reactions: {},
      );

      _chatService.sendMessage(chatId: widget.id, message: newMessage);

      setState(() {
        _pendingMessages = [];
      });

      final logMediaUrl = mediaUrls.isNotEmpty ? mediaUrls.first : "No Media";

      log('Message sent by $currentUserId: $text, $logMediaUrl');
    } catch (e) {
      log("Failed to send message: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send message.')));
      // If sending fails remove the pending message
      setState(() {
        _pendingMessages.removeWhere((msg) => msg.id == tempMessageId);
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _loadScreenshotPrivacy() async {
    try {
      final user = await AuthRepository().getUserDataByUuid(widget.userId);
      if (user == null) return;
      if (user.userType != UserType.individual) _screenshotPrivacy = ScreenshotPrivacy.allow;

      final doc = await FirebaseHelper.individualProfile
          .doc(user.refid)
          .collection('settings')
          .doc('preferences')
          .get();

      final setting = doc.data()?['screenshotPrivacy'] as String?;

      if (setting != null) {
        _screenshotPrivacy = ScreenshotPrivacy.values.firstWhere(
          (e) => e.name == setting,
          orElse: () => ScreenshotPrivacy.allow,
        );
      }
    } catch (e) {
      log('Failed to apply screenshot privacy: $e');
    }
  }

  void _listenForScreenshot() async {
    await _noScreenshot.startScreenshotListening();

    _noScreenshot.screenshotStream.listen((value) async {
      if (value.wasScreenshotTaken) {
        log("Screenshot taken");
        await NotificationServices().sendNotification(
          receiverUid: widget.userId,
          type: NotificationType.chatScreenshotTaken,
          payload: NotificationPayload(
            title: 'Chat Screenshot Taken',
            body: "${currentUser?.name ?? "Someone"} taken a screenshot of your chat.",
          ),
        );
      }
      ;
    });
  }

  Future<void> _applyScreenshotPrivacy() async {
    await _loadScreenshotPrivacy();

    log("Screenshot Privacy: $_screenshotPrivacy");

    switch (_screenshotPrivacy) {
      case ScreenshotPrivacy.allow:
        _noScreenshot.screenshotOn();
        break;

      case ScreenshotPrivacy.disallow:
        _noScreenshot.screenshotOff();
        break;

      case ScreenshotPrivacy.notify:
        _noScreenshot.screenshotOn();
        _listenForScreenshot();
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _audioRecorder = AudioRecorder();

    // Delay async logic until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeCurrentUser();
      await _applyScreenshotPrivacy();
    });
  }

  @override
  void dispose() async {
    _audioRecorder.dispose();
    _controller.dispose();

    await _noScreenshot.stopScreenshotListening();

    // re-enable on exit
    _noScreenshot.screenshotOn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCurrentUserInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: ChatAppBar(
        currentUserId: currentUserId,
        userid: widget.userId,
        userName: widget.name,
        profileImageUrl: widget.imageUrl,
        onBack: () => Navigator.pop(context),
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // image: DecorationImage(
          //   image: AssetImage('assets/images/chat_bg.png'),
          //   fit: BoxFit.cover,
          //   opacity: 1,
          //   colorFilter: ColorFilter.mode(Colors.black45, BlendMode.colorBurn),
          // ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _chatService.getMessages(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final fetchedMessages = snapshot.data ?? [];

                  if (fetchedMessages.isNotEmpty) {
                    _chatService.markMessagesAsSeen(widget.id, fetchedMessages);
                  }

                  final List<MessageModel> allMessages = [];
                  allMessages.addAll(_pendingMessages);
                  allMessages.addAll(
                    fetchedMessages.where((msg) => !_pendingMessages.any((pending) => pending.id == msg.id)),
                  );

                  allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: allMessages.length,
                    itemBuilder: (context, index) {
                      final message = allMessages[index];
                      final isMe = message.senderId == currentUserId;

                      // Check if this message is a pending one
                      final isPending = _pendingMessages.contains(message);

                      // message seen checker
                      final otherUserId = widget.userId;
                      final bool isSeen = message.seenBy.contains(otherUserId);

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primaryColor.withOpacity(isPending ? 0.6 : 1.0)
                                : Colors.white.withOpacity(isPending ? 0.6 : 1.0),
                            borderRadius: BorderRadius.circular(12),
                            border: isMe ? Border() : Border.all(color: AppColors.primaryColor),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (message.mediaUrl != null && message.type == MessageType.image)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AppImageViewer(
                                    message.mediaUrl ?? '',
                                    width: MediaQuery.sizeOf(context).width * 0.65,
                                    height: null,
                                  ),
                                ),
                              if (message.mediaUrl != null && message.type == MessageType.audio)
                                AppAudioPlayer(sourceUrl: message.mediaUrl ?? '', isSender: isMe),
                              if (message.content != null && message.content != '')
                                Text(
                                  message.content ?? '',
                                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                ),
                              //message seen ui on non-pending messages
                              if (isMe && !isPending)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        Helpers.getTimeAgo(message.timestamp.toString(), isShort: true),
                                        style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 10),
                                      ),
                                      Icon(
                                        Icons.done_all,
                                        size: 16,
                                        color: isSeen ? Colors.lightGreenAccent : Colors.white54,
                                      ),
                                    ],
                                  ),
                                ),
                              if (isMe && isPending)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Sending...',
                                    style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 12.sp),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatInputBar(
                controller: _controller,
                onSend: () => _sendMessage(fileToSend: _mediaFile, mediaType: _mediaType),
                onPickMedia: _pickMedia,
                mediaFile: _mediaFile,
                mediaType: _mediaType,
                isSending: _isSending,
                isRecording: _isRecording,
                onStartRecording: _startRecording,
                onStopRecording: _stopRecording,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickMedia;
  final File? mediaFile;
  final String? mediaType;
  final bool isSending;
  //audio
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPickMedia,
    this.mediaFile,
    this.mediaType,
    required this.isSending,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool isShowExtraOptions = false;
  _toggleShowExtraOptions({bool? val}) {
    setState(() {
      isShowExtraOptions = val ?? !isShowExtraOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRecording) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.mic, color: Colors.red, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text("Recording...", style: TextStyle(color: Colors.white)),
              ),
              GestureDetector(
                onTap: widget.onStopRecording,
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.stop, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(duration: Durations.medium2, alignment: Alignment.bottomCenter, child: SizedBox()),
          if (widget.mediaFile != null)
            Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildMediaPreview(),
            ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _toggleShowExtraOptions();
                },
                child: AnimatedRotation(
                  turns: isShowExtraOptions ? 0.125 : 0,
                  duration: Durations.medium2,
                  child: iconButton(Icons.add),
                ),
              ),
              const SizedBox(width: 8),
              iconButton(Icons.insert_drive_file),
              const SizedBox(width: 8),
              GestureDetector(onTap: widget.onPickMedia, child: iconButton(Icons.camera_alt)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  widget.onStartRecording();
                  _toggleShowExtraOptions(val: false);
                },
                child: iconButton(Icons.mic),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          decoration: const InputDecoration(hintText: 'Say Hi', border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: AppColors.primaryColor),
                        onPressed: widget.onSend,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (widget.mediaFile == null) return const SizedBox.shrink();

    // Render image preview
    if (widget.mediaType == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          widget.mediaFile!,

          // width: double.infinity,
          // height: 250,
          fit: BoxFit.fitHeight,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Failed to load image');
          },
        ),
      );
    }

    // Render video preview

    // Fallback widget
    return const SizedBox.shrink();
  }

  Widget iconButton(IconData icon) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFF675C), shape: BoxShape.circle),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String profileImageUrl;
  final VoidCallback onBack;
  final String userid;
  final String currentUserId;

  const ChatAppBar({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.onBack,
    required this.currentUserId,
    required this.userid,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          spacing: 10.r,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: onBack,
            ),

            // Profile Picture
            ProfilePicBlob(profilePicUrl: profileImageUrl, size: 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.r,
                children: [
                  GestureDetector(
                    onTap: () =>
                        context.pushNamed(AboutProfile.route, extra: (name: userName, imageUrl: profileImageUrl)),
                    child: Text(
                      userName,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      _roundIcon(Icons.chat_bubble_outline, text: '54'),
                      _roundIcon(Icons.calendar_month_outlined, text: '1'),
                      _roundIcon(Icons.info),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final callId = const Uuid().v4();
                          context.pushNamed(
                            CallScreen.route,
                            extra: (
                              name: userName,
                              imageUrl: profileImageUrl,
                              callId: callId,
                              isCaller: true,
                              isVideoCall: false,
                              localId: currentUserId,
                              remoteId: userid,
                            ),
                          );
                        },
                        child: _roundIcon(Icons.call),
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO video call
                          // final callId = const Uuid().v4();
                          // context.pushNamed(
                          //   CallScreen.route,
                          //   extra: (
                          //     name: userName,
                          //     imageUrl: profileImageUrl,
                          //     callId: callId,
                          //     isCaller: true,
                          //     isVideoCall: true,
                          //     localId: currentUserId,
                          //     remoteId: userid,
                          //   ),
                          // );
                        },
                        child: _roundIcon(Icons.videocam),
                      ),
                      _roundIcon(Icons.person, secondIcon: Icons.sync),
                    ],
                  ),
                ],
              ),
            ),
            _roundIcon(Icons.settings_outlined),
          ],
        ),
      ),
    );
  }

  static Widget _roundIcon(IconData icon, {String? text, IconData? secondIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.r),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(55)),
      child: Row(
        spacing: 6,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          if (text != null)
            Text(
              text,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          if (secondIcon != null) Icon(secondIcon, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(126);
}
