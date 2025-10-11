import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/sign_in_sign_up_button.dart';
import 'package:flutter_social_media/src/features/auth/presentation/sign_in_page.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  static const String route = 'email_verification_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'E-Mail Verification'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Icon(Icons.verified_user)),
            SizedBox(height: 20),
            Text("verification link has been sent to your email", style: AppTextStyles.bodyPeragraphGray),
            SizedBox(height: 50),
            SignInSignUpButton(
              onTap: () {
                context.pushReplacementNamed(SigninPage.route);
              },
              text: "Sign in",
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Didn’t got the link?',
                      style: TextStyle(color: Color(0xFF6C7278), fontSize: 14.sp, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 12.sp, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
