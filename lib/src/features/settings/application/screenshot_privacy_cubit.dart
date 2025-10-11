import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/settings/domain/interface/i_settings_repository.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/screenshot_privacy.dart';

part 'screenshot_privacy_cubit.freezed.dart';
part 'screenshot_privacy_state.dart';

class ScreenshotPrivacyCubit extends Cubit<ScreenshotPrivacyState> {
  final ISettingsRepository _settingsRepo;

  ScreenshotPrivacyCubit(this._settingsRepo) : super(const ScreenshotPrivacyState.initial());

  Future<void> loadPrivacy() async {
    emit(const ScreenshotPrivacyState.loading());
    try {
      final privacy = await _settingsRepo.getCurrentScreenshotPrivacy();
      emit(ScreenshotPrivacyState.success(privacy));
    } catch (e) {
      emit(ScreenshotPrivacyState.error('Failed to load screenshot privacy setting'));
    }
  }

  Future<void> updatePrivacy(ScreenshotPrivacy newPrivacy) async {
    emit(const ScreenshotPrivacyState.loading());
    try {
      await _settingsRepo.updateScreenshotPrivacy(newPrivacy);
      emit(ScreenshotPrivacyState.success(newPrivacy));
    } catch (e) {
      emit(ScreenshotPrivacyState.error('Failed to update screenshot privacy setting'));
    }
  }
}
