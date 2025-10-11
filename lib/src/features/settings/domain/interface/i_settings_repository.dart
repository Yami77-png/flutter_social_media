import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/screenshot_privacy.dart';

abstract class ISettingsRepository {
  Future<ProfilePicturePrivacy> getCurrentProfilePicturePrivacy();
  Future<void> updateProfilePicturePrivacy(ProfilePicturePrivacy privacy);

  Future<ScreenshotPrivacy> getCurrentScreenshotPrivacy();
  Future<void> updateScreenshotPrivacy(ScreenshotPrivacy newPrivacy);
}
