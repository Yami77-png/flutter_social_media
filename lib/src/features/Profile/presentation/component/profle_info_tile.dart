import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/info_icon_text.dart';

class ProfleInfoTile extends StatelessWidget {
  const ProfleInfoTile({super.key, required this.label, required this.infos});

  final String label;
  final List<InfoIconText> infos;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.sizeOf(context).width * 0.75,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          spacing: 5.h,
          children: [
            Text(
              label,
              style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2.h),
            ...infos,
          ],
        ),
      ),
    );
  }
}
