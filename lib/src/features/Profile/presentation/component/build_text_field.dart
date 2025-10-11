import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    super.key,
    this.label,
    required this.controller,
    this.icon,
    this.readOnly = false,
    this.onTap,
    this.hintText,
  });

  final String? label, hintText;
  final TextEditingController controller;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label ?? '',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          onTap: onTap,
          controller: controller,
          readOnly: readOnly,
          enabled: !readOnly,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon) : null,
            hintText: hintText,
            // filled: true,
            // fillColor: AppColors.gray200,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.r),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(127)],
        ),
      ],
    );
  }
}
