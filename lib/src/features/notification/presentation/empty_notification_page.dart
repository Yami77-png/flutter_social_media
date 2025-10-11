import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utility/app_colors.dart';

class EmptyNotificationPage extends StatelessWidget {
  const EmptyNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 3),
                ),
                child: Icon(Icons.notifications_off_outlined, size: 60, color: AppColors.primaryColor),
              ),
              SizedBox(height: 24),
              Text(
                "There’s no notifications",
                style: TextStyle(color: AppColors.primaryColor, fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "Your notifications will be appear on this page.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
