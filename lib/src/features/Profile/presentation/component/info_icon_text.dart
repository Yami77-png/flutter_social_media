import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';

class InfoIconText extends StatelessWidget {
  final IconData iconPath;
  final String label;

  const InfoIconText({super.key, required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.w,
      children: [
        Icon(iconPath),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyPeragraphGray.copyWith(color: AppColors.black800),
          ),
        ),
      ],
    );
  }
}
