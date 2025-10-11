import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/helpers/image_upload_helper.dart';
import '../../../core/utility/app_colors.dart';
import '../../NavPage/nav_wrapper_page.dart';
import '../../video_editor/presentation/video_crop_page.dart';
import '../../video_editor/presentation/video_editor_page.dart';
import '../application/create_post_cubit/create_post_cubit.dart';
import '../application/profile_pic_cubit/profile_pic_cubit.dart';
import '../domain/models/post.dart';
import 'components/attachment_buttons.dart';
import 'components/caption_text_field.dart';
import 'components/create_post_app_bar.dart';
import 'components/media_grid_preview.dart';
import 'components/post_card.dart';
import 'components/user_header.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, this.bindedPost});
  static String route = "create_post_page";

  final Post? bindedPost;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();

  List<XFile> _mediaFiles = [];
  final Map<String, Uint8List> _videoThumbnails = {};
  PostPrivacy _selectedPrivacy = PostPrivacy.PUBLIC;
  bool _canPost = false;
  bool _isAttachmentDialOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfilePicCubit>().getUserInfo();
    _captionController.addListener(_validatePostContent);
  }

  @override
  void dispose() {
    _captionController.removeListener(_validatePostContent);
    _captionController.dispose();
    super.dispose();
  }

  void _validatePostContent() {
    final hasText = _captionController.text.trim().isNotEmpty;
    final hasMedia = _mediaFiles.isNotEmpty;
    final isValid = hasText || hasMedia;

    if (_canPost != isValid) {
      setState(() {
        _canPost = isValid;
      });
    }
  }

  void _publishPost() {
    if (!_canPost) return;

    context.read<CreatePostCubit>().createPost(
      caption: _captionController.text,
      attachments: _mediaFiles.map((xfile) => File(xfile.path)).toList(),
      tags: [],
      isVideo: _mediaFiles.any((f) => f.path.toLowerCase().endsWith('.mp4')),
      isAudio: false,
      privacy: widget.bindedPost?.privacy ?? _selectedPrivacy,
      bindedPost: widget.bindedPost,
    );

    // Immediately navigate back to the feed.
    if (context.canPop()) {
      context.pop();
    } else {
      // Fallback if it can't be popped (e.g., deep link)
      context.goNamed(NavWrapperPage.route);
    }
  }

  bool _containsVideo() {
    return _mediaFiles.any((f) => f.path.toLowerCase().endsWith('.mp4'));
  }

  Future<void> _handlePickImages() async {
    if (_containsVideo()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Remove the video to add images.'), backgroundColor: AppColors.primaryColor),
      );
      return;
    }

    // Upload Images
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      // Crop Images
      final croppedFiles = await ImageUploadHelper().cropImages(pickedFiles);

      // Add final images
      if (croppedFiles.isNotEmpty) {
        setState(() {
          _mediaFiles.addAll(croppedFiles);
          _isAttachmentDialOpen = false;
        });
        _validatePostContent();
      }
    }
  }

  Future<void> _handlePickVideo() async {
    if (_mediaFiles.any((file) => file.mimeType?.startsWith('video') ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('You can only upload one video.'), backgroundColor: AppColors.primaryColor),
      );
      return;
    }

    final XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile == null || !mounted) return;

    // 1) Go to CropPage and get cropped video file back
    final cropResult = await context.pushNamed<Map<String, File?>>(
      VideoCropPage.route,
      extra: {'videoFile': File(pickedFile.path)},
    );
    if (!mounted || cropResult == null || cropResult['video'] == null) return;

    final croppedVideo = cropResult['video']!;

    // 2) Push to VideoEditorPage with cropped video file
    final videoEditorResult = await context.pushNamed<Map<String, File?>>(
      VideoEditorPage.route,
      extra: {'videoFile': croppedVideo},
    );
    if (!mounted || videoEditorResult == null) return;

    final editedVideo = videoEditorResult['video'];
    final thumbnailFile = videoEditorResult['thumbnail'];

    if (editedVideo != null) {
      final videoXFile = XFile(editedVideo.path);
      if (thumbnailFile != null) {
        final thumbnailBytes = await thumbnailFile.readAsBytes();
        _videoThumbnails[videoXFile.path] = thumbnailBytes;
      }

      setState(() {
        _mediaFiles.add(videoXFile);
        _isAttachmentDialOpen = false;
      });
      _validatePostContent();
    }
  }

  void _removeMediaFile(int index) {
    final fileToRemove = _mediaFiles[index];
    if (_videoThumbnails.containsKey(fileToRemove.path)) {
      _videoThumbnails.remove(fileToRemove.path);
    }

    setState(() {
      _mediaFiles.removeAt(index);
    });
    _validatePostContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CreatePostAppBar(canPost: _canPost, onPublish: _publishPost),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserHeader(
                  canSetPrivacy: widget.bindedPost == null,
                  selectedPrivacy: widget.bindedPost?.privacy ?? _selectedPrivacy,
                  onPrivacyChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _selectedPrivacy = newValue);
                    }
                  },
                ),
                const SizedBox(height: 16),
                CaptionTextField(controller: _captionController),
                const SizedBox(height: 20),
                MediaGridPreview(
                  mediaFiles: _mediaFiles,
                  videoThumbnails: _videoThumbnails,
                  onRemove: _removeMediaFile,
                ),
                if (widget.bindedPost != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.65, color: AppColors.gray, strokeAlign: 10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: PostCard(post: widget.bindedPost!),
                  ),
              ],
            ),
          ),
          if (widget.bindedPost == null)
            Positioned(
              top: 16,
              right: 16,
              child: AttachmentButtons(
                isOpen: _isAttachmentDialOpen,
                onToggle: () => setState(() => _isAttachmentDialOpen = !_isAttachmentDialOpen),
                onPickImages: _handlePickImages,
                onPickVideo: _handlePickVideo,
              ),
            ),
        ],
      ),
    );
  }
}
