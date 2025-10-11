import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_carousel_slider.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/feed_audio_player.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/posted_by_info.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/video_player.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostedByInfo(post: post),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          const SizedBox(height: 10),
          if (post.caption!.isNotEmpty) ...[
            SelectableText(
              post.caption!,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
          ],
          if (post.tags.isNotEmpty) ...[
            Wrap(spacing: 8, children: [for (var tag in post.tags) _buildTag(tag)]),
            const SizedBox(height: 10),
          ],
          SizedBox(height: 10),
          (post.attachment != null && post.attachment!.isNotEmpty)
              ? (post.isVideo == true)
                    ? VideoPlayerWidget(videoUrl: post.attachment!.first)
                    : (post.isAudio == true)
                    ? _buildAudioPlayer()
                    : AppCarouselSlider(items: post.attachment!)
              : const SizedBox.shrink(),
          if (post.bindedPostId != null)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 0.65, color: AppColors.gray, strokeAlign: 10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: PostCard(post: post.bindedPost!),
            ),
          // if (post.bindedPostId != null) Text(post.bindedPostId.toString()),
          // SizedBox(height: 10),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ],
      ),
    );
  }

  DecoratedBox _buildAudioPlayer() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: FeedAudioPlayer(url: post.attachment!.first),
      ),
    );
  }
}

Widget _buildTag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: Colors.redAccent.shade100, borderRadius: BorderRadius.circular(20)),
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1.1),
    ),
  );
}
