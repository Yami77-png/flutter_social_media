import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utility/app_text_style.dart';

class PostAction extends StatelessWidget {
  final IconData actionIcon;
  final String count;
  final Color iconColor;
  final double iconSize;
  final bool isSmall;

  const PostAction({
    super.key,
    required this.actionIcon,
    required this.count,
    this.iconColor = Colors.black,
    this.iconSize = 18,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: Color(0xFFBFBFBF), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: count != '0'
              ? 12.w
              : isSmall
              ? 2.w
              : 8.w,
          vertical: isSmall ? 2.h : 8.h,
        ),
        child: Row(
          spacing: 2.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(actionIcon, size: 20),
            if (count.isNotEmpty && count != '0')
              Text(
                count,
                style: AppTextStyles.appBarTitle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
