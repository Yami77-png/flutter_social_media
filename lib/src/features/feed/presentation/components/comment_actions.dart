import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/features/feed/application/like_comment_cubit/like_comment_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';

class CommentActions extends StatefulWidget {
  const CommentActions({super.key, required this.comment, required this.postId, this.onReplyTap});

  final String postId;
  final Comment comment;
  final VoidCallback? onReplyTap;

  @override
  State<CommentActions> createState() => _CommentActionsState();
}

class _CommentActionsState extends State<CommentActions> {
  Reaction? myReaction;

  @override
  Widget build(BuildContext context) {
    if (widget.comment.currentUserReaction != null) {
      myReaction = widget.comment.currentUserReaction;
    }

    // int reactionCount = int.tryParse(widget.comment.reactionCount.toString()) ?? 0;

    return BlocProvider(
      create: (_) => LikeCommentCubit(
        initialCount: int.tryParse(widget.comment.reactionCount.toString()) ?? 0,
        initialReaction: myReaction?.id,
      ),
      child: Builder(
        builder: (context) {
          return Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    Helpers.getTimeAgo(widget.comment.createdAt.toString(), isShort: true),
                    style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins', color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                  ),
                  InkWell(
                    onTap: widget.onReplyTap,
                    borderRadius: BorderRadius.circular(55),
                    // child: PostAction(svgIcon: Assets.commentIconSvg, count: commentCount.toString(), isSmall: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 6,
                        children: [Text("Reply", style: TextStyle(color: Colors.grey[700]))],
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<LikeCommentCubit, LikeCommentState>(
                builder: (context, state) {
                  final reactionCount = state.count;
                  return reactionCount > 0
                      ? Row(
                          children: [
                            Icon(Icons.add_reaction_outlined),
                            const SizedBox(width: 10),
                            Text(reactionCount.toString(), style: TextStyle(color: Colors.grey[700])),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
