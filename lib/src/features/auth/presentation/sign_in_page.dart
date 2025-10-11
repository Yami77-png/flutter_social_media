import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/core/helpers/permission_helper.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/sign_in_sign_up_button.dart';
import 'package:flutter_social_media/src/features/auth/application/sign_in_cubit/sign_in_cubit.dart';

class SigninPage extends StatefulWidget {
  SigninPage({super.key});
  static String route = "sign_in_page";

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool rememberMe = false;

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return const Scaffold(body: Center(child: Text('Localization not available')));
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildHeader(context, appLocalizations),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 40),
                child: _buildFormSection(context, appLocalizations),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations appLocalizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            '${appLocalizations.welcomeBack} 👋',
            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          ),
          Text(
            appLocalizations.helloAgainYouveBeenMissed,
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleBar(context, appLocalizations),
          const SizedBox(height: 24),
          _buildLabel(appLocalizations.email),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEDF1F3)),
              boxShadow: const [BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: appLocalizations.emailPlaceholder,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLabel(appLocalizations.password),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEDF1F3)),
              boxShadow: const [BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: appLocalizations.passwordPlaceholder,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  color: Colors.grey,
                  onPressed: () => _togglePasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildOptionsRow(context, appLocalizations),
          SizedBox(height: 24),
          BlocListener<SignInCubit, SignInState>(
            listener: (context, state) {
              state.map(
                initial: (_) {},
                loading: (_) {},
                success: (_) {
                  // Request Permissions
                  PermissionHelper().requestAllPermissions();

                  // Navigate to Feed Page
                  context.goNamed(NavWrapperPage.route);
                  context.read<ProfileCubit>().getUserInfo();
                },
                error: (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                },
              );
            },
            child: BlocBuilder<SignInCubit, SignInState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

                return SignInSignUpButton(
                  text: appLocalizations.signIn,
                  isLoading: isLoading,
                  onTap: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                    if (email.isNotEmpty && password.isNotEmpty) {
                      if (emailRegex.hasMatch(email)) {
                        context.read<SignInCubit>().signIn(email: email, password: password);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(appLocalizations.invalidEmailAddressError),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(appLocalizations.fillAllFieldsError),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildDivider(appLocalizations),
          const SizedBox(height: 24),

          _buildSocialButton(Assets.googleLogoPng, appLocalizations.continueWithGoogle),
          const SizedBox(height: 16),
          _buildSocialButton(null, appLocalizations.continueWithApple, icon: const Icon(Icons.apple, size: 24)),
        ],
      ),
    );
  }

  Widget _buildToggleBar(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      height: 36,
      decoration: BoxDecoration(color: const Color(0xFFF5F6F9), borderRadius: BorderRadius.circular(7)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0x7FEFF0F6)),
                boxShadow: const [BoxShadow(color: Color(0x3DE4E5E7), blurRadius: 2, offset: Offset(0, 1))],
              ),
              child: Center(
                child: Text(
                  appLocalizations.logIn,
                  style: TextStyle(
                    color: Color(0xFF232447),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.pushNamed(SignUpPage.route, extra: UserType.individual);
              },
              child: Center(
                child: Text(
                  appLocalizations.signUp,
                  style: TextStyle(
                    color: Color(0xFF7D7D91),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Color(0xFF6C7278), fontSize: 12.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
    );
  }

  Widget _buildOptionsRow(BuildContext context, AppLocalizations appLocalizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              appLocalizations.rememberMe,
              style: TextStyle(color: Color(0xFF6C7278), fontSize: 12.sp, fontFamily: 'Poppins'),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(ResetPasswordPage.route);
          },
          child: Text(
            '${appLocalizations.forgotPassword}?',
            style: TextStyle(color: Color(0xFF6C7278), fontSize: 12.sp, fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(AppLocalizations appLocalizations) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            appLocalizations.or,
            style: TextStyle(color: Color(0xFF6C7278), fontSize: 12.sp, fontFamily: 'Poppins'),
          ), // Modified
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButton(String? imagePath, String text, {Icon? icon}) {
    return OutlinedButton(
      onPressed: () {
        final appLocalizations = AppLocalizations.of(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLocalizations!.comingSoon)));
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Color(0xFFEFF0F6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null) Image.asset(imagePath, height: 24, width: 24) else if (icon != null) icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF232447),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
