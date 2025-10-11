import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/feed/application/posts_cubit.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/vote_buttons.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_action.dart';
import 'package:flutter_social_media/src/features/feed/presentation/post_details_page.dart';

class PostActions extends StatelessWidget {
  PostActions({super.key, required this.postId, this.onBindingTap});

  final String postId;
  final VoidCallback? onBindingTap;

  @override
  Widget build(BuildContext context) {
    final post = context.select<PostsCubit, Post?>((cubit) => cubit.state[postId]);

    if (post == null) return SizedBox();

    return Row(
      spacing: 8.w,
      children: [
        VoteButtons(post: post),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed(PostDetailsPage.route, pathParameters: {'id': post.id}, extra: post);
          },
          child: PostAction(
            actionIcon: Icons.mode_comment_outlined,
            iconColor: AppColors.black,
            count: '${post.commentCount}',
          ),
        ),
        // SizedBox(width: 38.w),
        Spacer(),
        if (onBindingTap == null) SizedBox(width: 46.w),
        if (onBindingTap != null)
          GestureDetector(
            onTap: onBindingTap,
            child: PostAction(
              actionIcon: Icons.loop_outlined,
              iconColor: AppColors.black,
              count: '${post.bindedPostCount}',
            ),
          ),
        GestureDetector(
          onTap: () {
            Helpers.sharePost(post);
          },
          child: PostAction(actionIcon: Icons.link_rounded, iconColor: AppColors.black, count: ""),
        ),
      ],
    );
  }
}
