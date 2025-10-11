// Reusable button widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AboutProfileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const AboutProfileButton({
    Key? key,
    required this.label,
    required this.icon,
    this.iconColor,
    this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor ?? AppColors.black),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16.sp, color: textColor ?? AppColors.black),
              ),
            ),
            if (label == "Media") Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}
