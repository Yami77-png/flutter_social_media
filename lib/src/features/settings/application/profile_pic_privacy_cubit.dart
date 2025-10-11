import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';
import 'package:flutter_social_media/src/features/settings/domain/interface/i_settings_repository.dart';

part 'profile_pic_privacy_state.dart';
part 'profile_pic_privacy_cubit.freezed.dart';

class ProfilePicPrivacyCubit extends Cubit<ProfilePicPrivacyState> {
  final ISettingsRepository _settingsRepo;
  final IAuthRepository _authRepo;

  ProfilePicPrivacyCubit(this._settingsRepo, this._authRepo) : super(const ProfilePicPrivacyState.initial());

  Future<void> loadPrivacy() async {
    emit(const ProfilePicPrivacyState.loading());
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) {
        emit(const ProfilePicPrivacyState.error('User not found.'));
        return;
      }

      if (user.userType != UserType.individual) {
        // Privacy settings only apply to individual users
        emit(ProfilePicPrivacyState.success(ProfilePicturePrivacy.public, user.userType));
        return;
      }

      final privacy = await _settingsRepo.getCurrentProfilePicturePrivacy();
      emit(ProfilePicPrivacyState.success(privacy, user.userType));
    } catch (e, st) {
      log('Failed to load privacy: $e', stackTrace: st);
      emit(const ProfilePicPrivacyState.error('Failed to load privacy settings.'));
    }
  }

  Future<void> updatePrivacy(ProfilePicturePrivacy privacy) async {
    emit(const ProfilePicPrivacyState.loading());
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) {
        emit(const ProfilePicPrivacyState.error('User not found.'));
        return;
      }

      if (user.userType != UserType.individual) {
        emit(const ProfilePicPrivacyState.error('Only individual users can update privacy settings.'));
        return;
      }

      await _settingsRepo.updateProfilePicturePrivacy(privacy);
      emit(ProfilePicPrivacyState.success(privacy, user.userType));
    } catch (e, st) {
      log('Failed to update privacy: $e', stackTrace: st);
      emit(const ProfilePicPrivacyState.error('Failed to update privacy.'));
    }
  }
}
