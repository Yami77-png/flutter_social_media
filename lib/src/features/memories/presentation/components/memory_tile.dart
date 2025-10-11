import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';

class MemoryTile extends StatelessWidget {
  const MemoryTile({super.key, required this.memory, this.height, this.width, this.onTap});

  final Post memory;
  final double? height, width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            AppImageViewer(memory.attachment?.first ?? '', width: width ?? 138.w, height: height ?? double.infinity),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                spacing: 6,
                children: [
                  ProfilePicBlob(profilePicUrl: memory.postedBy.imageUrl, size: 30.r),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        memory.postedBy.name,
                        style: AppTextStyles.shadow.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                            size: 10.sp,
                            shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1)],
                          ),
                          Text(
                            Helpers.getTimeAgo(memory.postedAt, isShort: true),
                            style: AppTextStyles.shadow.copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
