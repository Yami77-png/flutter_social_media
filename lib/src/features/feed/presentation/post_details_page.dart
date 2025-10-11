import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_post_comments/fetch_post_comments_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/selected_media.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_carousel_slider.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/comment_tile.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_actions.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_card.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/posted_by_info.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/comment_gif_sticker_bottom_sheet.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/video_player.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key, this.post, this.postId, this.isVideo = false});

  static const String route = 'post_details_page';

  final Post? post;
  final String? postId;
  final bool isVideo;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  TextEditingController commentController = TextEditingController();
  String? replyToCommentId;
  final commentFocusNode = FocusNode();
  final ValueNotifier<bool> canSubmitNotifier = ValueNotifier(false);
  bool isSubmitting = false;
  SelectedMedia? _selectedMedia;

  Post? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      _post = widget.post!;
      _isLoading = false;
      _getPostComments(); // we already have post
    } else if (widget.postId != null) {
      _fetchPost(); // deep link
    } else {
      // Error case: no post or postId
      _isLoading = false;
    }
  }

  Future<void> _fetchPost() async {
    final fetchedPost = await FeedRepository().fetchPostById(widget.postId!);
    if (fetchedPost != null) {
      setState(() {
        _post = fetchedPost;
        _isLoading = false;
      });
      _getPostComments();
    } else {
      setState(() => _isLoading = false);
    }
  }

  _getPostComments() {
    if (_post != null) {
      context.read<FetchPostCommentsCubit>().fetchComments(_post!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_post == null) {
      return const Scaffold(body: Center(child: Text("Post not found")));
    }

    final post = _post!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        if (replyToCommentId != null) {
          replyToCommentId = null;
          commentFocusNode.unfocus();
        } else {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppAppBar(title: 'POST', onBackFallback: NavWrapperPage.route),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  PostedByInfo(post: post),
                  const SizedBox(height: 10),
                  Text(post.caption ?? '', style: TextStyle(fontSize: 14.sp, height: 1.5)),
                  const SizedBox(height: 10),
                  if (post.attachment?.isNotEmpty == true)
                    post.isVideo == true
                        ? VideoPlayerWidget(videoUrl: post.attachment!.first)
                        : AppCarouselSlider(items: post.attachment!),
                  if (post.bindedPostId != null)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.65, color: AppColors.gray, strokeAlign: 10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PostCard(post: post.bindedPost!),
                    ),
                  const SizedBox(height: 8),
                  PostActions(postId: post.id),
                  const Divider(height: 20),
                  _buildCommentSection(post),
                ],
              ),
            ),
            _buildCommentInput(post),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection(Post post) {
    return BlocBuilder<FetchPostCommentsCubit, FetchPostCommentsState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          loaded: (data) {
            if (data.comments.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No comments yet. Be the first to comment!"),
              );
            }

            final commentsByParentId = <String?, List<Comment>>{};
            for (final comment in data.comments) {
              commentsByParentId.putIfAbsent(comment.parentId, () => []).add(comment);
            }
            final baseComments = commentsByParentId[null] ?? [];

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: baseComments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final comment = baseComments[index];
                return CommentTile(
                  comment: comment,
                  postId: post.id,
                  replyToCommentId: replyToCommentId,
                  commentsByParentId: commentsByParentId,
                  onReplyTap: (String commentId) {
                    setState(() {
                      replyToCommentId = commentId;
                    });
                    FocusScope.of(context).requestFocus(commentFocusNode);
                    log('Replying to ($replyToCommentId)');
                  },
                );
              },
            );
          },
          error: (_) => const Center(child: Text("Failed to load comments")),
        );
      },
    );
  }

  Widget _makeMediaPreview() {
    if (_selectedMedia == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            Container(
              height: 100, // Fixed height for the preview
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: AspectRatio(
                aspectRatio: _selectedMedia!.aspectRatio,
                child: AppImageViewer(_selectedMedia!.url, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => setState(() => _selectedMedia = null),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.black,
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput(Post post) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // media preview
            _makeMediaPreview(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  border: Border.all(color: AppColors.gray),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: commentFocusNode,
                        controller: commentController,
                        onChanged: (_) {
                          final text = commentController.text.trim();
                          canSubmitNotifier.value = text.isNotEmpty || _selectedMedia != null;
                        },

                        decoration: const InputDecoration(hintText: 'Type your comment...', border: InputBorder.none),
                      ),
                    ),
                    // action buttons
                    isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(onTap: () {}, child: const Icon(Icons.add, size: 20)),
                              const SizedBox(width: 8),
                              // Sticker Button
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  // Call the sheet with the STICKER type
                                  final result = await showCommentGifStickerBottomSheet(
                                    context,
                                    mediaType: SearchMediaType.sticker,
                                  );
                                  if (result != null) {
                                    setState(() => _selectedMedia = result);
                                  }
                                },
                                child: const Icon(Icons.emoji_emotions_outlined, size: 20),
                              ),
                              const SizedBox(width: 8),
                              // GIF Button
                              InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  // Call the sheet with the GIF type
                                  final result = await showCommentGifStickerBottomSheet(
                                    context,
                                    mediaType: SearchMediaType.gif,
                                  );
                                  if (result != null) {
                                    setState(() => _selectedMedia = result);
                                  }
                                },
                                child: const Icon(Icons.gif_box_outlined, size: 20),
                              ),
                              const SizedBox(width: 8),
                              ValueListenableBuilder<bool>(
                                valueListenable: canSubmitNotifier,
                                builder: (context, canSubmit, _) {
                                  return GestureDetector(
                                    onTap: canSubmit ? () => _submitComment(post) : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: canSubmit ? AppColors.primaryColor : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.send, color: Colors.white, size: 16),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // handle comment submission
  Future<void> _submitComment(Post post) async {
    setState(() => isSubmitting = true);

    final commentText = commentController.text.trim();
    bool success = false;

    // Case 1: The user selected a GIF (and maybe also typed some text)
    if (_selectedMedia != null) {
      success = await FeedRepository().addCommentToPost(
        postId: post.id,
        notificationReceiverId: post.postedBy.id,
        parentCommentId: replyToCommentId,
        type: _selectedMedia!.type,
        mediaUrl: _selectedMedia!.url,
        aspectRatio: _selectedMedia!.aspectRatio,
        commentText: commentText.isNotEmpty ? commentText : null,
      );
    }
    // Case 2: The user is only posting text
    else if (commentText.isNotEmpty) {
      success = await FeedRepository().addCommentToPost(
        postId: post.id,
        notificationReceiverId: post.postedBy.id,
        parentCommentId: replyToCommentId,
        type: CommentType.text,
        commentText: commentText,
      );
    }

    if (success && mounted) {
      // Reset everything after a successful post
      commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _selectedMedia = null;
        replyToCommentId = null;
      });
      context.read<FetchPostCommentsCubit>().fetchComments(post.id);
    }

    if (mounted) {
      setState(() => isSubmitting = false);
    }
  }
}
