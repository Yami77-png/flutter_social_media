import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> videoUrls = [];

  final List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (var url in videoUrls) {
      final controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      _controllers.add(controller);
    }

    _controllers[_currentIndex].play();
  }

  void _onPageChanged(int index) {
    setState(() {
      _controllers[_currentIndex].pause();
      _currentIndex = index;
      _controllers[_currentIndex].play();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final controller = _controllers[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              controller.value.isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),

              // Example Overlay UI
              Positioned(
                left: 16,
                bottom: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@username',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    SizedBox(height: 8),
                    Text('This is a caption for the video...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 80,
                child: Column(
                  children: const [
                    Icon(Icons.favorite, color: Colors.white, size: 32),
                    SizedBox(height: 16),
                    Icon(Icons.comment, color: Colors.white, size: 32),
                    SizedBox(height: 16),
                    Icon(Icons.share, color: Colors.white, size: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
