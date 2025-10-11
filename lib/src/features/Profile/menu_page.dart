import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/logout_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/component/menu_section.dart';
import 'package:flutter_social_media/src/features/Profile/component/my_status_section.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileOverview(),
              const SizedBox(height: 26),
              MyStatusSection(),
              const SizedBox(height: 26),
              BlocProvider(create: (context) => LogoutCubit(AuthRepository()), child: MenuSection()),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<ProfileCubit, ProfileState> _buildProfileOverview() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.map(
          loading: (value) => Center(child: CircularProgressIndicator.adaptive()),
          loaded: (value) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                switch (value.user.userType) {
                  case UserType.individual:
                    context.pushNamed(
                      IndividualProfilePage.route,
                      extra: (
                        user: value.user,
                        individual: value.individualProfile,
                        business: value.businessProfile,
                        professional: value.professionalProfile,
                        contentCreator: value.contentCreatorProfile,
                      ),
                    );
                  case UserType.business:
                  case UserType.contentCreator:
                  case UserType.professional:
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  spacing: 12,
                  children: [
                    ProfilePicBlob(profilePicUrl: value.user.imageUrl),
                    Expanded(
                      child: Text(
                        value.user.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primaryColor),
                  ],
                ),
              ),
            );
          },
          error: (value) {
            return Center(child: Text(value.e));
          },
        );
      },
    );
  }
}
