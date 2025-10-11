import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';

class AlreadyKnotted extends StatelessWidget {
  const AlreadyKnotted({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 0.75, color: Colors.black54),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.people_outline_rounded),
            Text(
              'Friends',
              style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
