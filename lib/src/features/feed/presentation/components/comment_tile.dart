import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/comment_actions.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.postId,
    required this.onReplyTap,
    required this.commentsByParentId,
    required this.replyToCommentId,
  });
  final Comment comment;
  final String postId;
  final String? replyToCommentId;
  final Map<String?, List<Comment>> commentsByParentId;
  final ValueChanged<String> onReplyTap;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _areRepliesVisible = false;

  Widget _displayCommentContent(BuildContext context) {
    final comment = widget.comment;

    // Determine if text or media content exists
    final bool hasText = comment.text != null && comment.text!.trim().isNotEmpty;
    final bool hasMedia = comment.mediaUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display text if it exists
        if (hasText)
          Padding(
            // Add spacing below the text only if there is media as well
            padding: EdgeInsets.only(top: 4, bottom: hasMedia ? 8.0 : 4.0),
            child: Text(comment.text!),
          ),

        // Display media (GIF/Sticker) if it exists
        if (hasMedia)
          Padding(
            // Ensure consistent spacing
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: comment.aspectRatio ?? 1.0, // Default to 1:1 if null
                child: Image.network(
                  comment.mediaUrl!,
                  fit: BoxFit.cover,
                  // Show a placeholder while the image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: AppColors.grayLight);
                  },
                  // Show an error icon if the media fails to load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.grayLight,
                      child: Center(child: Icon(Icons.error, color: AppColors.gray)),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final replies = widget.commentsByParentId[widget.comment.id] ?? [];
    // NEW: The widget determines its own 'isReplying' status
    final bool isReplying = widget.comment.id == widget.replyToCommentId;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: isReplying ? 0.15 : 0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicBlob(profilePicUrl: widget.comment.userProfileUrl, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.comment.userName, style: TextStyle(fontWeight: FontWeight.w600)),
                      _displayCommentContent(context),
                      CommentActions(
                        postId: widget.postId,
                        comment: widget.comment,
                        onReplyTap: () => widget.onReplyTap(widget.comment.id),
                      ),
                      if (widget.comment.commentCount != null && widget.comment.commentCount! > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _areRepliesVisible = !_areRepliesVisible;
                                });
                              },
                              child: Text(
                                _areRepliesVisible ? 'Hide replies' : 'View ${widget.comment.commentCount} replies',
                                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
              ],
            ),
          ),

          if (_areRepliesVisible && replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 38.0, top: 8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: replies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  return CommentTile(
                    comment: reply,
                    postId: widget.postId,
                    commentsByParentId: widget.commentsByParentId,
                    onReplyTap: widget.onReplyTap,
                    replyToCommentId: widget.replyToCommentId,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
