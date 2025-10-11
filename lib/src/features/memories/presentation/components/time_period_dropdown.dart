import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/core/utility/components/app_drop_down.dart';

class TimePeriodDropdown extends StatelessWidget {
  final int? value;
  final void Function(dynamic)? onChanged;
  const TimePeriodDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final TextStyle btnStyle = AppTextStyles.buttonText.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400);

    return AppDropDown(
      buttonHeight: 26.h,
      buttonWidth: 90.w,
      value: value,
      valueStyle: btnStyle,
      hintText: 'Duration',
      hintStyle: btnStyle,
      onChanged: onChanged,
      bgColor: Color(0xFFEEEEEE).withValues(alpha: 0.1),
      borderColor: Color(0xFFEEEEEE).withValues(alpha: 0.1),
      iconColor: Colors.white,
      dropdownColor: Colors.black54,
      buttonPadding: EdgeInsets.symmetric(horizontal: 6.w),
      iconSize: 12.sp,
      items: [1, 4, 8, 24].map<DropdownMenuItem>((value) {
        return DropdownMenuItem(
          value: value,
          child: Text('$value Hour', style: btnStyle),
        );
      }).toList(),
    );
  }
}
