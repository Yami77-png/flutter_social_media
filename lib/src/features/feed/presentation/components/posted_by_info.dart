import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/core/helpers/profile_picture_helper.dart';
import 'package:flutter_social_media/src/core/helpers/public_avatar_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_search_cubit/profile_search_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/feed/application/posts_cubit.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';

class PostedByInfo extends StatefulWidget {
  const PostedByInfo({super.key, required this.post, this.size = 44});

  final Post post;
  final double size;

  @override
  State<PostedByInfo> createState() => _PostedByInfoState();
}

class _PostedByInfoState extends State<PostedByInfo> {
  bool _isLoadingUser = false;
  _setLoadingUser(bool val) => setState(() => _isLoadingUser = val);
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _getProfilePicture();
  }

  Future<void> _getProfilePicture() async {
    final currentUserId = await HiveHelper.getCurrentUserId();
    final isCurrentUser = widget.post.postedBy.id == currentUserId;

    String? imageUrl;

    if (isCurrentUser) {
      // Use profile picture directly for current user
      imageUrl = widget.post.postedBy.imageUrl;
    } else {
      imageUrl = await ProfilePictureHelper().getProfilePictureUrl(
        widget.post.postedBy.id,
        fallbackToPublicAvatarIfNull: true,
      );
    }

    if (mounted) {
      setState(() {
        _profilePictureUrl = imageUrl;
      });
    }
  }

  Future<void> _onProfileTap() async {
    _setLoadingUser(true);

    try {
      final profileArgs = await context.read<ProfileSearchCubit>().getSearchUserInfo(widget.post.postedBy.id);
      if (profileArgs == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not load user profile.')));
        }
        return;
      }

      final fallbackAvatar = PublicAvatarHelper().getAssetPath(profileArgs.individualProfile?.publicAvatar);

      _updatePostedByInfo(name: profileArgs.user.name, imageUrl: _profilePictureUrl ?? fallbackAvatar);

      if (!mounted) return;

      // Navigate to profile
      switch (profileArgs.user.userType) {
        case UserType.individual:
          context.pushNamed(
            IndividualProfilePage.route,
            extra: (
              user: profileArgs.user,
              individual: profileArgs.individualProfile,
              business: profileArgs.businessProfile,
              professional: profileArgs.professionalProfile,
              contentCreator: profileArgs.contentCreatorProfile,
            ),
          );
          break;
        case UserType.business:
        case UserType.contentCreator:
        case UserType.professional:
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      _setLoadingUser(false);
    }
  }

  _updatePostedByInfo({required String name, required String imageUrl}) {
    final postedByInfo = widget.post.postedBy;
    if (name != postedByInfo.name || imageUrl != postedByInfo.imageUrl) {
      FeedRepository().updatePostedByInfo(postId: widget.post.id, newName: name, newImageUrl: imageUrl);
    }
    context.read<PostsCubit>().updatePost(
      widget.post.copyWith(
        postedBy: widget.post.postedBy.copyWith(name: name, imageUrl: imageUrl),
      ),
    );
  }

  _getPrivacyIcon(PostPrivacy privacy) {
    switch (privacy) {
      case PostPrivacy.PUBLIC:
        return Icons.public_rounded;
      case PostPrivacy.FRIENDS:
        return Icons.people_outline_outlined;
      case PostPrivacy.ONLYME:
        return Icons.lock_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        GestureDetector(
          onTap: _isLoadingUser ? null : _onProfileTap,
          child: ProfilePicBlob(profilePicUrl: _profilePictureUrl, size: 50),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Row(
              spacing: 6,
              children: [
                GestureDetector(
                  onTap: _isLoadingUser ? null : _onProfileTap,
                  child: Text(
                    widget.post.postedBy.name,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_isLoadingUser) SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            Row(
              spacing: 6,
              children: [
                Icon(_getPrivacyIcon(widget.post.privacy), size: 20),
                Text(Helpers.getTimeAgo(widget.post.postedAt)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
