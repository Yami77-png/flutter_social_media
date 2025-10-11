import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/helpers/public_avatar_helper.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';

class SwipeableProfilePicture extends StatefulWidget {
  final String? profileImage;
  final bool isFemale;
  final String? publicAvatar;
  final File? mediaFile;
  final bool isCurrentUser;
  final bool isLoading;
  final VoidCallback onPickMedia;

  const SwipeableProfilePicture({
    Key? key,
    required this.profileImage,
    required this.isFemale,
    required this.publicAvatar,
    required this.mediaFile,
    required this.isCurrentUser,
    required this.isLoading,
    required this.onPickMedia,
  }) : super(key: key);

  @override
  _SwipeableProfilePictureState createState() => _SwipeableProfilePictureState();
}

class _SwipeableProfilePictureState extends State<SwipeableProfilePicture> {
  late List<Widget> _pages;
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _buildPages();
  }

  @override
  void didUpdateWidget(covariant SwipeableProfilePicture oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mediaFile != oldWidget.mediaFile ||
        widget.profileImage != oldWidget.profileImage ||
        widget.publicAvatar != oldWidget.publicAvatar) {
      _buildPages();
    }
  }

  void _buildPages() {
    final List<Widget> pages = [];

    final String? trimmedProfileImage = widget.profileImage?.trim();
    final bool hasProfileImage =
        widget.mediaFile != null || (trimmedProfileImage != null && trimmedProfileImage.isNotEmpty);

    // Only add profile picture if it exists
    if (hasProfileImage) {
      final String profilePicUrl = widget.mediaFile?.path ?? trimmedProfileImage!;
      pages.add(
        Center(
          child: ProfilePicBlob(profilePicUrl: profilePicUrl, profilePicFile: widget.mediaFile, size: 120),
        ),
      );
    }

    // Add avatar if present
    final String? trimmedAvatar = widget.publicAvatar?.trim();
    if (trimmedAvatar != null && trimmedAvatar.isNotEmpty) {
      pages.add(
        Center(child: ProfilePicBlob(profilePicUrl: PublicAvatarHelper().getAssetPath(trimmedAvatar), size: 120)),
      );
    }

    setState(() {
      _pages = pages;
      if (_currentIndex >= _pages.length) _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
              _buildDots(),
            ],
          ),
        ),

        // Camera Icon - only on profile pic page
        if (widget.isCurrentUser && !widget.isLoading && _currentIndex == 0)
          Positioned(
            bottom: 25,
            right: 0,
            child: Material(
              color: Colors.white.withOpacity(0.33),
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onPickMedia,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDots() {
    if (_pages.length <= 1) return const SizedBox(height: 28);
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: _currentIndex == index ? 10 : 8,
            height: _currentIndex == index ? 10 : 8,
            decoration: BoxDecoration(
              color: _currentIndex == index ? AppColors.primaryColor : AppColors.gray,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
