import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AppTextStyles {
  static final TextStyle buttonText = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: 0.0,
    color: Colors.white,
  );
  static final TextStyle bodyPeragraphGray = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1.0, // 100% line height
    letterSpacing: 0.0,
    color: const Color(0xFF898989),
  );
  static final TextStyle title = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: 0.0,
    color: const Color(0xFF454545),
  );
  static final TextStyle appBarTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    height: 26 / 18,
    letterSpacing: 0.0,
    color: Colors.black,
  );
  static TextStyle primaryColorTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24.sp,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.primaryColor,
  );
  static TextStyle switchTitle = GoogleFonts.lora(
    fontWeight: FontWeight.w400,
    fontSize: 10.sp,
    height: 1.2,
    letterSpacing: 0,
    color: Colors.black,
  );
  static final TextStyle shadow = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: 0.0,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 1)],
  );
}
