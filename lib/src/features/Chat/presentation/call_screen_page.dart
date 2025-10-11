import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Chat/application/call_cubit.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/sandbox/webroomrtc.dart';

class CallScreen extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  String? callId;
  final bool isCaller;
  final bool isVideoCall;
  final String localId;
  final String remoteId;

  CallScreen({
    super.key,
    this.name,
    this.imageUrl,
    this.callId,
    required this.isCaller,
    required this.isVideoCall,
    required this.localId,
    required this.remoteId,
  });

  static const String route = 'call_screen_page';
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _webrtcService = WebRTCRoomService();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  // String? _activeCallId;

  StreamSubscription? _callStatusSubscription;

  Userx? user;

  Timer? _callTimer;
  int _elapsedSeconds = 0;
  String _formattedTime = '';
  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
        final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
        final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
        _formattedTime = '$minutes:$seconds';
      });
    });
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
    _elapsedSeconds = 0;
  }

  MediaStream? localStream;
  MediaStreamTrack? userMic;
  MediaStreamTrack? userVideo; //TODO: toggle camera on/off on video call

  Future<void> _initLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});

    final audioTracks = localStream!.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      userMic = audioTracks.first;
    }

    final videoTracks = localStream!.getAudioTracks();
    if (videoTracks.isNotEmpty) {
      userVideo = videoTracks.first;
    }
  }

  @override
  void initState() {
    print('callId: ${widget.callId}, callerName: ${widget.name}, callerImg: ${widget.imageUrl}');
    _initLocalStream();
    _getCurrentUser();
    _initializeRenderers();
    _startOrAnswerCall();
    _listenToCallStatus();
    super.initState();
  }

  _getCurrentUser() async {
    user = await AuthRepository().getCurrentUserData();
  }

  void _listenToCallStatus() {
    log('listening to call status');
    final roomRef = FirebaseFirestore.instance.collection('call_test').doc(widget.callId);

    _callStatusSubscription = roomRef.snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;

      final status = data['status'];
      if (status == CallStatus.ended.name || status == CallStatus.declined.name) {
        _handleCallEndedUI();
      }
    });
  }

  void _handleCallEndedUI() {
    log('Call ended');
    context.read<CallCubit>().callEnded(callId: widget.callId);
    context.pop();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startOrAnswerCall() async {
    var user = await AuthRepository().getCurrentUserData();
    if (widget.isCaller) {
      log('_startOrAnswerCall() called');
      widget.callId = await _webrtcService.createRoom(receiverId: widget.remoteId, isVideo: widget.isVideoCall);
      log('_webrtcService.createRoom() complete: ${widget.callId}');
    } else {
      await _webrtcService.joinRoom(widget.callId ?? '', video: widget.isVideoCall);
    }

    final localRenderer = _webrtcService.getLocalRenderer(widget.callId ?? '');
    final remoteRenderer = _webrtcService.getLocalRenderer(widget.callId ?? '');

    if (localRenderer != null) {
      _localRenderer = localRenderer;
    }

    // Watch for changes to the remote stream
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (remoteRenderer != null) {
          _remoteRenderer = remoteRenderer;
        }
      });
    });
    _startCallTimer();
  }

  @override
  void dispose() {
    _webrtcService.dispose(widget.callId ?? '');
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _callStatusSubscription?.cancel();
    _stopCallTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localRenderer = widget.callId != null ? _webrtcService.getLocalRenderer(widget.callId!) : null;
    final remoteRenderer = widget.callId != null ? _webrtcService.getRemoteRenderer(widget.callId!) : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.imageUrl ??
                  'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.25,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.colorBurn),
          ),
        ),
        child: BlocConsumer<CallCubit, CallStatus>(
          listener: (_, state) {
            if (state == CallStatus.ended) {
              // WebRTCRoomService().endCall(widget.callId);
              log('Call declined/ended. Going back.');
              // context.pop();
            }
          },
          builder: (_, state) {
            return Stack(
              children: [
                // Remote video
                // if (widget.isVideoCall)
                //   Positioned.fill(
                //     child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                //   )
                // if (!widget.isVideoCall) Center(child: Icon(Icons.mic, size: 100, color: Colors.white70)),
                if (!widget.isVideoCall)
                  Center(
                    child: Column(
                      spacing: 12,
                      children: [
                        SizedBox(height: 90),
                        Container(
                          width: 111,
                          height: 111,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: AppColors.primaryColor),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.imageUrl ??
                                    'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          widget.name.toString(),
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                // Local video (small overlay)
                if (widget.isVideoCall)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              user?.imageUrl ??
                                  'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                            ),
                            fit: BoxFit.cover,
                            opacity: 1,
                            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
                          ),
                        ),
                        child: remoteRenderer != null
                            ? RTCVideoView(remoteRenderer)
                            : Center(
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2, color: AppColors.primaryColor),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        user?.imageUrl ??
                                            'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SafeArea(
                        child: Container(
                          height: 175,
                          width: 125,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            image: localRenderer != null
                                ? null
                                : DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.imageUrl ??
                                          'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                    opacity: 1,
                                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
                                  ),
                          ),
                          child: localRenderer != null
                              ? RTCVideoView(localRenderer, mirror: true)
                              : Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 2, color: AppColors.primaryColor),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.imageUrl ??
                                              'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           image: DecorationImage(
                //             image: NetworkImage(
                //               widget.imageUrl ??
                //                   'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                //             ),
                //             fit: BoxFit.cover,
                //             opacity: 1,
                //             colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
                //           ),
                //         ),
                //         child:
                //             localRenderer != null
                //                 ? RTCVideoView(localRenderer, mirror: true)
                //                 : Center(
                //                   child: Container(
                //                     width: 75,
                //                     height: 75,
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       border: Border.all(width: 2, color: AppColors.primaryColor),
                //                       image: DecorationImage(
                //                         image: NetworkImage(
                //                           widget.imageUrl ??
                //                               'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                //                         ),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.grey,
                //           image: DecorationImage(
                //             image: NetworkImage(
                //               user?.imageUrl ??
                //                   'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                //             ),
                //             fit: BoxFit.cover,
                //             opacity: 1,
                //             colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
                //           ),
                //         ),
                //         child:
                //             remoteRenderer != null
                //                 ? RTCVideoView(remoteRenderer)
                //                 : Center(
                //                   child: Container(
                //                     width: 75,
                //                     height: 75,
                //                     decoration: BoxDecoration(
                //                       shape: BoxShape.circle,
                //                       border: Border.all(width: 2, color: AppColors.primaryColor),
                //                       image: DecorationImage(
                //                         image: NetworkImage(
                //                           user?.imageUrl ??
                //                               'https://t3.ftcdn.net/jpg/09/48/09/30/360_F_948093078_6kRWXnAWFNEaakRMX5OM9CRNNj2gdIfw.jpg',
                //                         ),
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //       ),
                //     ),
                //   ],
                // ),

                // Text("Room ID: $_activeCallId"),
                // ElevatedButton(
                //   onPressed: () async {
                //     if (_activeCallId != null) {
                //       await _webrtcService.dispose(_activeCallId!);
                //       setState(() {
                //         _activeCallId = null;
                //       });
                //     }
                //   },
                //   child: const Text('Hang Up'),
                //   ),
                // Positioned(
                //   top: 30,
                //   right: 20,
                //   width: 120,
                //   height: 160,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.white54),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: RTCVideoView(_localRenderer, mirror: true),
                //   ),
                // ),

                // timer
                Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                // Call controls
                Positioned(bottom: 50, left: 0, right: 0, child: _callControlsRow(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  bool isMicOn = true;
  _callMicToggle() {
    setState(() {
      isMicOn = !isMicOn;
    });
    if (userMic != null) {
      userMic!.enabled = isMicOn;
    }
  }

  bool isVolumeLoud = false;
  _callVolumeToggle() async {
    setState(() {
      isVolumeLoud = !isVolumeLoud;
    });
    await Helper.setSpeakerphoneOn(isVolumeLoud);
  }

  Row _callControlsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          heroTag: 'mic',
          onPressed: _callMicToggle,
          shape: CircleBorder(),
          backgroundColor: Colors.white.withValues(alpha: isMicOn ? 0.2 : 0.5),
          child: Icon(isMicOn ? Icons.mic : Icons.mic_off, color: Colors.white, size: 30),
        ),
        FloatingActionButton(
          heroTag: 'volume',
          onPressed: _callVolumeToggle,
          shape: CircleBorder(),
          backgroundColor: Colors.white.withValues(alpha: !isVolumeLoud ? 0.2 : 0.5),
          child: Icon(isVolumeLoud ? Icons.volume_up : Icons.volume_down, color: Colors.white, size: 30),
        ),
        FloatingActionButton(
          heroTag: 'callend',
          onPressed: () async {
            await context.read<CallCubit>().callEnded(callId: widget.callId);
            context.pop();
          },
          shape: CircleBorder(),
          backgroundColor: Colors.red,
          child: Icon(Icons.call_end_rounded),
        ),
      ],
    );
  }
}
