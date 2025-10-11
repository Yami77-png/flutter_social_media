import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditBtn extends StatelessWidget {
  const ProfileEditBtn({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        spacing: 8,
        children: [
          Text(
            'Edit',
            style: TextStyle(color: Colors.black, fontSize: 14.sp),
          ),
          Icon(Icons.edit),
        ],
      ),
    );
  }
}
