import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onTap, required this.label, this.isOutlined = false});

  final VoidCallback? onTap;
  final String label;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isOutlined ? Colors.white : AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
      ),
      child: FittedBox(
        child: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(
            color: isOutlined ? AppColors.black800 : Colors.white,
            fontWeight: isOutlined ? FontWeight.w300 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
