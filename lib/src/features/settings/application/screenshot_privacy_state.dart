part of 'screenshot_privacy_cubit.dart';

@freezed
class ScreenshotPrivacyState with _$ScreenshotPrivacyState {
  const factory ScreenshotPrivacyState.initial() = _Initial;
  const factory ScreenshotPrivacyState.loading() = _Loading;
  const factory ScreenshotPrivacyState.success(ScreenshotPrivacy privacy) = _Success;
  const factory ScreenshotPrivacyState.error(String message) = _Error;
}
