import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AudioCoverPhotoSelectionButtons extends StatefulWidget {
  AudioCoverPhotoSelectionButtons({super.key, required this.coverPhotoSelected, required this.pickCoverImage});

  bool coverPhotoSelected;
  final Future<void> Function() pickCoverImage;

  @override
  State<AudioCoverPhotoSelectionButtons> createState() => _AudioCoverPhotoSelectionButtonsState();
}

class _AudioCoverPhotoSelectionButtonsState extends State<AudioCoverPhotoSelectionButtons> {
  @override
  Widget build(BuildContext context) {
    if (!widget.coverPhotoSelected) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          // Keep Cover Photo
          onPressed: () {
            setState(() {
              widget.coverPhotoSelected = false;
            });
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: AppColors.primaryColor.withAlpha(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Keep', style: TextStyle(fontSize: 16, color: AppColors.black800)),
              const SizedBox(width: 10),
              Icon(Icons.check),
            ],
          ),
        ),

        TextButton(
          // Change Cover Photo
          onPressed: () {
            widget.pickCoverImage();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: AppColors.gray200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Change', style: TextStyle(fontSize: 16, color: AppColors.black800)),
              const SizedBox(width: 10),
              Icon(Icons.flip_camera_ios_outlined, size: 28, color: AppColors.black800),
            ],
          ),
        ),
      ],
    );
  }
}
