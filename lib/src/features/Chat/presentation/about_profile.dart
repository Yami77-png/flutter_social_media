import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/Chat/presentation/components/about_profile_button.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';

class AboutProfile extends StatelessWidget {
  const AboutProfile({super.key, required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  static const route = "about_profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(title: "About"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile pic
              Center(child: ProfilePicBlob(profilePicUrl: imageUrl, size: 100)),

              const SizedBox(height: 16),

              // Name
              Text(name, style: AppTextStyles.primaryColorTitleStyle.copyWith(color: AppColors.black)),
              const SizedBox(height: 32),

              // Media
              AboutProfileButton(label: 'Media', icon: Icons.image_outlined, onTap: () {}),
              const SizedBox(height: 12),

              // Report
              AboutProfileButton(
                label: 'Report',
                icon: Icons.error_outline,
                iconColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              // Block
              AboutProfileButton(
                label: 'Block',
                icon: Icons.block,
                iconColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
