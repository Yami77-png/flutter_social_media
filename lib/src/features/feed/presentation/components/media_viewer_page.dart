import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:video_player/video_player.dart';

class MediaViewerPage extends StatefulWidget {
  static const route = "media_viewer_page";
  final List<XFile> mediaFiles;
  final int initialIndex;

  const MediaViewerPage({super.key, required this.mediaFiles, required this.initialIndex});

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaFiles.length,
        itemBuilder: (context, index) {
          // This is the dispatcher widget. It decides what to show.
          return _MediaViewerItem(file: widget.mediaFiles[index]);
        },
      ),
    );
  }
}

/// A dispatcher widget that inspects the file type and delegates to the
/// appropriate viewer.
class _MediaViewerItem extends StatelessWidget {
  final XFile file;
  const _MediaViewerItem({required this.file});

  @override
  Widget build(BuildContext context) {
    // Use the file extension for a more reliable check than mimeType.
    final isVideo = file.path.toLowerCase().endsWith('.mp4');

    if (isVideo) {
      return _VideoPlayerViewer(file: File(file.path));
    } else {
      return _ImageViewer(file: File(file.path));
    }
  }
}

/// A dedicated widget to display a single image, with zoom/pan capabilities.
class _ImageViewer extends StatelessWidget {
  final File file;
  const _ImageViewer({required this.file});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Center(child: Image.file(file, fit: BoxFit.contain)),
    );
  }
}

/// A dedicated stateful widget to handle video playback.
class _VideoPlayerViewer extends StatefulWidget {
  final File file;
  const _VideoPlayerViewer({required this.file});

  @override
  State<_VideoPlayerViewer> createState() => _VideoPlayerViewerState();
}

class _VideoPlayerViewerState extends State<_VideoPlayerViewer> {
  late final VideoPlayerController _videoController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _videoController.play();
            _videoController.setLooping(true);
          });
        }
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoController),
              if (!_videoController.value.isPlaying) const Icon(Icons.play_arrow, color: Colors.white70, size: 80),
            ],
          ),
        ),
      ),
    );
  }
}
