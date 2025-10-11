import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/auth/presentation/reset_password_page.dart';

class SubmitCode extends StatelessWidget {
  const SubmitCode({super.key});

  @override
  Widget build(BuildContext context) {
    // Common styles
    TextStyle titleStyle = TextStyle(
      color: Color(0xFF131313),
      fontSize: 18.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );

    TextStyle subtitleStyle = TextStyle(
      color: Color(0xFF898989),
      fontSize: 14.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: Color(0xFFFF675C), shape: BoxShape.circle),
                  child: Icon(Icons.navigate_before, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Forgot password', style: titleStyle),
                  const SizedBox(height: 8),
                  Text(
                    'We sent a reset link to abcd....@gmail.com\nEnter the 6-digit code mentioned in the email.',
                    style: subtitleStyle,
                  ),
                  const SizedBox(height: 32),

                  // Code input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCodeBox('5'),
                      _buildCodeBox('1'),
                      _buildCodeBox('7'),
                      _buildCodeBox('3'),
                      _buildCodeBox('9'),
                      _buildCodeBox('6'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add verification logic for the 6-digit code

                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF675C),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Verify Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Resend email
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: subtitleStyle,
                        children: [
                          const TextSpan(text: 'Haven’t got the email yet? '),
                          TextSpan(
                            text: 'Resend email.',
                            style: TextStyle(color: Color(0xFFFF675C), fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // TODO: Add resend email functionality
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCodeBox(String number) {
    return Container(
      width: 45,
      height: 46,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.5, color: Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        number,
        style: TextStyle(color: Color(0xFF898989), fontSize: 24.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      ),
    );
  }
}
