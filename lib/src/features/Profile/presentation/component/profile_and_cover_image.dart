import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_image_cubit/profile_image_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/swipable_profile_picture.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/carousel_media_viewer_page.dart';

class ProfileAndCoverImage extends StatefulWidget {
  final String profileImage;
  final String coverImage;
  final String? publicAvatar;
  final bool isCurrentUser;
  final bool isCenterImage;
  final bool isFemale;

  const ProfileAndCoverImage({
    super.key,
    required this.profileImage,
    required this.coverImage,
    required this.isCurrentUser,
    required this.isCenterImage,
    required this.isFemale,
    this.publicAvatar,
  });

  @override
  State<ProfileAndCoverImage> createState() => _ProfileAndCoverImageState();
}

class _ProfileAndCoverImageState extends State<ProfileAndCoverImage> {
  File? _mediaFile;
  File? _mediaFileCover;
  bool isUpdatingProfileImage = false;
  bool isUpdatingCoverImage = false;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia({required bool isCoverImage}) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isCoverImage) {
          _mediaFileCover = File(pickedFile.path);
          isUpdatingCoverImage = true;
        } else {
          _mediaFile = File(pickedFile.path);
          isUpdatingProfileImage = true;
        }
      });
    }
  }

  void _setIsLoading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _clearValues() {
    setState(() {
      _mediaFile = null;
      _mediaFileCover = null;
      isUpdatingCoverImage = false;
      isUpdatingProfileImage = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileImageProvider = _mediaFile != null
        ? FileImage(_mediaFile!)
        : (widget.profileImage.trim().isNotEmpty
                  ? CachedNetworkImageProvider(widget.profileImage.trim())
                  : AssetImage(widget.isFemale ? Assets.femalePlaceholder10Png : Assets.malePlaceholder1Png))
              as ImageProvider;

    final coverImageProvider = _mediaFileCover != null
        ? FileImage(_mediaFileCover!)
        : (widget.coverImage.trim().isNotEmpty
                  ? CachedNetworkImageProvider(widget.coverImage.trim())
                  : const AssetImage(Assets.googleLogoPng)) // TODO: Replace with suitable image
              as ImageProvider;

    return BlocProvider(
      create: (_) => ProfileImageCubit(),
      child: BlocConsumer<ProfileImageCubit, ProfileImageState>(
        listener: (context, state) {
          state.map(
            initial: (_) {},
            loadingProfileImage: (_) => _setIsLoading(true),
            loadingCoverImage: (_) => _setIsLoading(true),
            success: (_) {
              _clearValues();
              context.read<ProfileCubit>().getUserInfo();
            },
            error: (_) => _setIsLoading(false),
          );
        },
        builder: (context, state) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showImageBottomSheet(context, isCoverImage: true);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 225,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.33),
                            border: Border.all(
                              color: isUpdatingCoverImage ? AppColors.primaryColor : Colors.transparent,
                              width: 5,
                            ),
                            image: DecorationImage(
                              image: coverImageProvider,
                              fit: (_mediaFileCover != null || widget.coverImage.trim().isNotEmpty)
                                  ? BoxFit.cover
                                  : BoxFit.contain,
                            ),
                          ),
                        ),
                        if (widget.isCurrentUser && !isLoading)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Material(
                              color: Colors.white.withOpacity(0.33),
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                // onTap: () => _pickMedia(isCoverImage: true),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),

              Transform.translate(
                offset: Offset(widget.isCenterImage ? 0 : -130, -65),
                child: GestureDetector(
                  onTap: () {
                    // _showImageBottomSheet(context, isCoverImage: false);
                    context.pushNamed(
                      CarouselMediaViewerPage.route,
                      queryParameters: {'index': '0'},
                      extra: [widget.profileImage],
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: SwipeableProfilePicture(
                          profileImage: widget.profileImage,
                          isFemale: widget.isFemale,
                          publicAvatar: widget.publicAvatar,
                          mediaFile: _mediaFile,
                          isCurrentUser: widget.isCurrentUser,
                          isLoading: isLoading,
                          // onPickMedia: () => _pickMedia(isCoverImage: false),
                          onPickMedia: () {
                            _showImageBottomSheet(context, isCoverImage: false);
                          },
                        ),
                      ),
                      if (isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -60),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: (isUpdatingProfileImage || isUpdatingCoverImage)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _clearValues,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(color: AppColors.primaryColor, width: 2),
                                ),
                              ),
                              child: Text('Cancel', style: AppTextStyles.buttonText.copyWith(color: AppColors.black)),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                final cubit = context.read<ProfileImageCubit>();
                                if (isUpdatingProfileImage && _mediaFile != null) {
                                  cubit.updateUserImage(_mediaFile!.path, isCoverImage: false);
                                }
                                if (isUpdatingCoverImage && _mediaFileCover != null) {
                                  cubit.updateUserImage(_mediaFileCover!.path, isCoverImage: true);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              ),
                              child: Text('Confirm', style: AppTextStyles.buttonText),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> _showImageBottomSheet(BuildContext context, {required bool isCoverImage}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 24.r),
          child: Column(
            spacing: 8.r,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  context.pop();
                  context.pushNamed(
                    CarouselMediaViewerPage.route,
                    queryParameters: {'index': '0'},
                    extra: isCoverImage ? [widget.coverImage] : [widget.profileImage],
                  );
                },
                leading: Icon(Icons.image_search_rounded),
                title: Text('View Profile Picture'),
              ),
              ListTile(
                onTap: () {
                  context.pop();
                  _pickMedia(isCoverImage: isCoverImage);
                },
                leading: Icon(Icons.file_upload_outlined),
                title: Text('Upload Profile Picture'),
              ),
            ],
          ),
        );
      },
    );
  }
}
