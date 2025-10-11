import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class ProfilePrivacySwitch extends StatefulWidget {
  const ProfilePrivacySwitch({super.key});

  @override
  State<ProfilePrivacySwitch> createState() => _ProfilePrivacySwitchState();
}

class _ProfilePrivacySwitchState extends State<ProfilePrivacySwitch> {
  bool isPublic = true;
  updateIsPublic(bool val) {
    setState(() {
      isPublic = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isPublic ? 'Profile Public' : 'Profile Private', style: TextStyle(fontSize: 10.sp)),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: isPublic,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primaryColor,
            onChanged: updateIsPublic,
          ),
        ),
      ],
    );
  }
}
