import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton({super.key, required this.text, required this.iconPath, this.onTap});
  final String text;
  final IconData iconPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            AppSnackbar.show(context, message: 'Comming soon!');
          },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          spacing: 14.w,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(text, style: AppTextStyles.shadow),
            Icon(iconPath),
          ],
        ),
      ),
    );
  }
}
