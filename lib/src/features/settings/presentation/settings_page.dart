import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/settings/application/profile_pic_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/application/screenshot_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/infrastructure/settings_repository.dart';
import 'package:flutter_social_media/src/features/settings/presentation/components/locale_selector.dart';
import 'package:flutter_social_media/src/features/settings/presentation/components/profile_picture_privacy_selector.dart';
import 'package:flutter_social_media/src/features/settings/presentation/components/screenshot_privacy_selector.dart';

class SettingsPage extends StatefulWidget {
  static const String route = 'settings_page';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfilePicPrivacyCubit>().loadPrivacy();
    context.read<ScreenshotPrivacyCubit>().loadPrivacy();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations == null) {
      return const Scaffold(body: Center(child: Text('Localization not available')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Change language
            LocaleSelector(),

            SizedBox(height: 30.h),

            // Profile picture privacy
            BlocProvider(
              create: (context) => ProfilePicPrivacyCubit(SettingsRepository(), AuthRepository())..loadPrivacy(),
              child: const ProfilePicturePrivacySelector(),
            ),

            SizedBox(height: 30.h),

            // Screenshot Privacy
            ScreenshotPrivacySelector(),
          ],
        ),
      ),
    );
  }
}
