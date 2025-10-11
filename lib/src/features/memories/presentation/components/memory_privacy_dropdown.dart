import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/core/utility/components/app_drop_down.dart';

class MemoryPrivacyDropdown extends StatelessWidget {
  const MemoryPrivacyDropdown({super.key, required this.value, required this.onChanged});

  final PostPrivacy value;
  final void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    _getPrivacyIcon(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return Icons.public_rounded;
        case PostPrivacy.FRIENDS:
          return Icons.people_outline_outlined;
        case PostPrivacy.ONLYME:
          return Icons.lock_outline_rounded;
      }
    }

    _getPrivacyName(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return "Public";
        case PostPrivacy.FRIENDS:
          return "Friends";
        case PostPrivacy.ONLYME:
          return "Only Me";
      }
    }

    final TextStyle btnStyle = AppTextStyles.buttonText.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400);

    return AppDropDown(
      buttonHeight: 26.h,
      buttonWidth: 90.w,
      value: value,
      valueStyle: btnStyle,
      hintText: 'Privacy',
      onChanged: onChanged,
      bgColor: Color(0xFFEEEEEE).withValues(alpha: 0.1),
      borderColor: Color(0xFFEEEEEE).withValues(alpha: 0.1),
      iconColor: Colors.white,
      dropdownColor: Colors.black54,
      buttonPadding: EdgeInsets.symmetric(horizontal: 6.w),
      iconSize: 12.sp,
      items: PostPrivacy.values.map<DropdownMenuItem>((value) {
        return DropdownMenuItem(
          value: value,
          child: Row(
            children: [
              Icon(_getPrivacyIcon(value), color: AppColors.white),
              const SizedBox(width: 6),
              Text(_getPrivacyName(value), style: btnStyle),
            ],
          ),
        );
      }).toList(),
    );
  }
}
