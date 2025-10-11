import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/features/auth/application/rest_password_cubit/rest_password_cubit.dart';
import 'package:flutter_social_media/src/features/auth/presentation/rest_password_emai_success_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static const String route = 'reset_password_page';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  // Common styles
  final TextStyle titleStyle = TextStyle(
    color: Color(0xFF131313),
    fontSize: 18.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  final TextStyle subtitleStyle = TextStyle(
    color: Color(0xFF898989),
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 20),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                  child: Icon(Icons.navigate_before, color: Colors.white, size: 20),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Forgot password', style: titleStyle),
                  const SizedBox(height: 5),
                  Text('Please enter your email to reset the password.', style: subtitleStyle),
                  const SizedBox(height: 48),

                  Text('Your email', style: titleStyle),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 15, offset: Offset(0, 4))],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: subtitleStyle,
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF898989)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reset Password Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocListener<RestPasswordCubit, RestPasswordState>(
                      listener: (context, state) {
                        state.map(
                          initial: (_) {},
                          loading: (_) {
                            // Show a loading indicator or disable input
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );
                          },
                          success: (_) {
                            context.pushReplacementNamed(RestPasswordEmailSuccessPage.route);
                          },
                          failure: (errorState) {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorState.message)));
                          },
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<RestPasswordCubit>().restPassword(email: emailController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 4,
                          shadowColor: const Color(0x0C000000),
                        ),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
}
