import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/sign_in_sign_up_button.dart';
import 'package:flutter_social_media/src/features/auth/presentation/sign_in_page.dart';

class RestPasswordEmailSuccessPage extends StatelessWidget {
  const RestPasswordEmailSuccessPage({super.key});
  static const String route = 'rest_password_email_success_page';

  @override
  Widget build(BuildContext context) {
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
          children: [
            // Main success content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Green success circle with check icon
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 25),

                  Text('We’ve Sent You a Password Reset Email', style: titleStyle),
                  SizedBox(height: 5),

                  Text(
                    'A password reset link has been sent to your email.\nPlease check your inbox to proceed.',
                    textAlign: TextAlign.center,
                    style: subtitleStyle,
                  ),
                ],
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SignInSignUpButton(
                onTap: () {
                  context.goNamed(SigninPage.route);
                },
                text: 'Sign in',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
