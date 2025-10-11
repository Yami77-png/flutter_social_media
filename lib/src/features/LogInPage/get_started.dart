import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/components/language_dropdown.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/presentation/sign_up_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/features/auth/presentation/sign_in_page.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  static Color primaryColor = AppColors.primaryColor;
  static const Color secondaryTextColor = Color(0xFF898989);
  static const Color textColor = Color(0xFF131313);
  static const double topContentOffset = 0.35;
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 32);

  static String route = 'get_started_page';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background color
          Container(color: Colors.white),

          // Main content
          SafeArea(
            child: Stack(
              children: [
                // Language selector dropdown
                Positioned(top: 16, right: 16, child: SafeArea(child: LanguageDropdownTopRightCorner())),

                // Main content
                Positioned(
                  top: screenHeight * topContentOffset,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: horizontalPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Flutter Social Media",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 28.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            letterSpacing: -0.41,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          appLocalizations.letsConnect,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 22.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            letterSpacing: -0.41,
                          ),
                        ),
                        const SizedBox(height: 64),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pushNamed(SigninPage.route);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 2,
                              shadowColor: AppColors.primaryColor.withOpacity(0.3),
                            ),
                            child: Text(
                              appLocalizations.signIn,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(SignUpPage.route, extra: UserType.individual);
                          },
                          child: Text(
                            appLocalizations.createAnAccount,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
    );
  }
}
