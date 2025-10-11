import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AttachmentButtons extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;

  const AttachmentButtons({
    required this.isOpen,
    required this.onToggle,
    required this.onPickImages,
    required this.onPickVideo,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onToggle,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
                color: Colors.white,
              ),
              child: Center(
                child: AnimatedRotation(
                  turns: isOpen ? 0.125 : 0.0,
                  duration: duration,
                  child: const Icon(Icons.add, color: Colors.black, size: 28),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: duration,
          curve: Curves.easeInOut,
          height: isOpen ? 96 : 0,
          width: 44,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(22)),
              child: Column(
                children: [
                  _iconChild(icon: Icons.videocam_outlined, onTap: onPickVideo),
                  const SizedBox(height: 8),
                  _iconChild(icon: Icons.image_outlined, onTap: onPickImages),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconChild({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(icon, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
