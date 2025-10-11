import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/HomePage/voiceover_page.dart';
import '../feed/presentation/create_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  bool _fabExpanded = false;
  final bool _hasNotification = true;
  final bool _hasMessage = true;

  void toggleFab() {
    setState(() {
      _fabExpanded = !_fabExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 7, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_fabExpanded) ...[
                  _fabOption("Post", Icons.edit, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostPage()));
                  }),
                  const SizedBox(height: 10),
                  _fabOption("Voice", Icons.mic, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceOverPage()));
                  }),
                  const SizedBox(height: 10),
                  _fabOption("Live Stream", Icons.podcasts, () {}),
                  const SizedBox(height: 10),
                  _fabOption("Memories", Icons.image, () {}),
                  const SizedBox(height: 10),
                ],
                FloatingActionButton(
                  backgroundColor: AppColors.primaryColor,
                  onPressed: toggleFab,
                  child: Icon(_fabExpanded ? Icons.close : Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabIcon(String assetPath, {bool showNotification = false}) {
    return Tab(
      icon: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: SizedBox(height: 28, width: 28, child: Image.asset(assetPath, fit: BoxFit.contain)),
            ),
          ),
          if (showNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fabOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
        toggleFab();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _pageTemplate(String title) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Text(title, style: TextStyle(fontSize: 20.sp)),
    ),
  );
}
