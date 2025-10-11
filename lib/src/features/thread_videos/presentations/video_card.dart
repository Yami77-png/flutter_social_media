import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';

class VideoCard extends StatelessWidget {
  final String? thumbnailUrl;
  final String avatarUrl;
  final String title;
  final String timeAgo;
  final String description;
  final String views;
  VoidCallback ontap;

  VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.avatarUrl,
    required this.title,
    required this.timeAgo,
    required this.description,
    required this.views,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background: Thumbnail or fallback icon
              _buildBackground(),

              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Content overlay
              Positioned(bottom: 10, left: 10, right: 10, child: _buildOverlayContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (thumbnailUrl == null) {
      return const Center(child: Icon(Icons.videocam, size: 80, color: Colors.grey));
    }

    if (thumbnailUrl!.startsWith('http') || thumbnailUrl!.startsWith('https')) {
      return AppImageViewer(
        thumbnailUrl!,
        fit: BoxFit.cover,
        errorWidget: const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
      );
    }

    // ✅ Decode path only if it's encoded
    final decodedPath = Uri.decodeFull(thumbnailUrl!);
    final file = File(decodedPath);

    // ✅ Check if file exists before rendering
    if (!file.existsSync()) {
      debugPrint("File does not exist at path: $decodedPath");
      return const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey));
    }

    log("File path: $file");
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
    );
  }

  Widget _buildOverlayContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar and title
        Row(
          children: [
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(avatarUrl), radius: 16),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white70, size: 12),
                      SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (description.isNotEmpty)
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
            SizedBox(width: 2),
            Text(views, style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
