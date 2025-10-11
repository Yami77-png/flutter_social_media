import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/settings/application/profile_pic_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';

class ProfilePicturePrivacySelector extends StatelessWidget {
  const ProfilePicturePrivacySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    final Map<ProfilePicturePrivacy, (String, String)> privacyOptions = {
      ProfilePicturePrivacy.public: (localizations.public, localizations.publicDescription),
      ProfilePicturePrivacy.knots: (localizations.knots, localizations.knotsDescription),
      ProfilePicturePrivacy.onlyMe: (localizations.onlyMe, localizations.onlyMeDescription),
    };

    return BlocBuilder<ProfilePicPrivacyCubit, ProfilePicPrivacyState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        final hasError = state.maybeWhen(error: (_) => true, orElse: () => false);
        final selectedPrivacy = state.maybeWhen(success: (privacy, _) => privacy, orElse: () => null);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.profilePicturePrivacy, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12.h),
            DropdownButtonFormField<ProfilePicturePrivacy>(
              value: selectedPrivacy,
              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        context.read<ProfilePicPrivacyCubit>().updatePrivacy(value);
                      }
                    },
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                ),
              ),
              selectedItemBuilder: (context) {
                return ProfilePicturePrivacy.values.map((privacy) {
                  final title = privacyOptions[privacy]!.$1;
                  return Align(alignment: Alignment.centerLeft, child: Text(title));
                }).toList();
              },
              items: ProfilePicturePrivacy.values.asMap().entries.map((entry) {
                final index = entry.key;
                final privacy = entry.value;
                final isLast = index == ProfilePicturePrivacy.values.length - 1;

                final title = privacyOptions[privacy]!.$1;
                final subtitle = privacyOptions[privacy]!.$2;

                return DropdownMenuItem(
                  value: privacy,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13.sp, color: AppColors.gray),
                      ),
                      if (!isLast) SizedBox(height: 12.h),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (isLoading) ...[SizedBox(height: 8.h), const LinearProgressIndicator()],
            if (hasError) ...[
              SizedBox(height: 8.h),
              const Text('Failed to load profile picture privacy.', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        );
      },
    );
  }
}
