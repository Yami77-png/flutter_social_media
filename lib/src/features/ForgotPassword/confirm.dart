import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Confirm extends StatelessWidget {
  const Confirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildBackButton(context),
              SizedBox(height: 40),
              Text(
                'Password reset',
                style: TextStyle(
                  color: Color(0xFF131313),
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your password has been successfully reset.\nClick confirm to set a new password.',
                style: TextStyle(
                  color: Color(0xFF898989),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: Color(0xFFFF675C), shape: BoxShape.circle),
        child: Icon(Icons.navigate_before, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement navigation or next step
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF675C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
        ),
        child: Text('Confirm', style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      ),
    );
  }
}
