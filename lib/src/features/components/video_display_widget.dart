// --------------------- VIDEO DISPLAY ---------------------
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/media_model.dart';

class VideoDisplayWidget extends StatefulWidget {
  final MediaModel media;

  const VideoDisplayWidget({super.key, required this.media});

  @override
  State<VideoDisplayWidget> createState() => _VideoDisplayWidgetState();
}

class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.media.url)
      ..initialize()
          .then((_) {
            setState(() => _isInitialized = true);
          })
          .catchError((e) {
            debugPrint('Video init error: $e');
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoHeight = screenWidth / widget.media.aspectRatioValue;

    if (!_isInitialized) {
      return SizedBox(
        width: screenWidth,
        height: screenWidth, //videoHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: SizedBox(
        width: screenWidth,
        height: screenWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),
            if (!_controller.value.isPlaying) const Icon(Icons.play_circle_outline, size: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
