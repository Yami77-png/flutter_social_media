import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_actions.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String views;
  final String postedByAvatar;
  final String postedByName;
  final String timeAgo;
  final String id;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.views,
    required this.postedByAvatar,
    required this.postedByName,
    required this.timeAgo,
    required this.id,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),

        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
            child: AnimatedOpacity(
              opacity: _controller.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black45,
                child: Center(child: Icon(Icons.play_arrow, size: 64, color: Colors.white)),
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_controller.value.position),
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                  Text(
                    _formatDuration(_controller.value.duration),
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoDetails() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("${widget.views} views • ${widget.timeAgo}", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.postedByAvatar)),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.postedByName)),
              TextButton(onPressed: () {}, child: const Text("Connect")),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.description),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Comment section coming soon."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Column(
              children: [
                _buildVideoPlayer(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      children: [
                        _buildVideoDetails(),
                        PostActions(postId: widget.id),
                        const Divider(),
                        _buildCommentsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
