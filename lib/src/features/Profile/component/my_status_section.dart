import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';

class MyStatusSection extends StatelessWidget {
  const MyStatusSection({super.key});

  static const List<UserStatus> userStatusList = [UserStatus.away, UserStatus.work, UserStatus.game, UserStatus.busy];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Status",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => Center(child: CircularProgressIndicator.adaptive()),
              loaded: (value) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(userStatusList.length, (i) {
                  final status = userStatusList[i];
                  return _statusChip(status.text, () {
                    context.read<ProfileCubit>().updateUserStatus(status);
                  }, isSelected: value.user.myStatus == status.name);
                }),
              ),
              error: (value) {
                return Center(child: Text(value.e));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _statusChip(String label, VoidCallback onTap, {bool isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: isSelected ? 0.85 : 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
