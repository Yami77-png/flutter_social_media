import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/settings/application/screenshot_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/screenshot_privacy.dart';

class ScreenshotPrivacySelector extends StatelessWidget {
  const ScreenshotPrivacySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return const SizedBox.shrink();

    // Texts
    final Map<ScreenshotPrivacy, (String, String)> privacyOptions = {
      ScreenshotPrivacy.allow: (localizations.screenshotAllow, localizations.screenshotAllowDescription),
      ScreenshotPrivacy.disallow: (localizations.screenshotDisallow, localizations.screenshotDisallowDescription),
      ScreenshotPrivacy.notify: (localizations.screenshotNotify, localizations.screenshotNotifyDescription),
    };

    return BlocBuilder<ScreenshotPrivacyCubit, ScreenshotPrivacyState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        final hasError = state.maybeWhen(error: (_) => true, orElse: () => false);
        final selectedPrivacy = state.maybeWhen(success: (privacy) => privacy, orElse: () => null);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.screenshotPrivacy, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12.h),
            DropdownButtonFormField<ScreenshotPrivacy>(
              value: selectedPrivacy,
              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        context.read<ScreenshotPrivacyCubit>().updatePrivacy(value);
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
                return ScreenshotPrivacy.values.map((privacy) {
                  final title = privacyOptions[privacy]!.$1;
                  return Align(alignment: Alignment.centerLeft, child: Text(title));
                }).toList();
              },
              items: ScreenshotPrivacy.values.asMap().entries.map((entry) {
                final index = entry.key;
                final privacy = entry.value;
                final isLast = index == ScreenshotPrivacy.values.length - 1;

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
              Text('Failed to load screenshot privacy.', style: TextStyle(color: AppColors.primaryColor, fontSize: 12)),
            ],
          ],
        );
      },
    );
  }
}
