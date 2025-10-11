import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ReelsPage1 extends StatelessWidget {
  const ReelsPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> reelImages = [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.red),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Reels',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: reelImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) => MediaCard(imagePath: reelImages[index], views: '4.3M'),
        ),
      ),
    );
  }
}

class MediaCard extends StatelessWidget {
  final String imagePath;
  final String views;

  const MediaCard({super.key, required this.imagePath, required this.views});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    views,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
