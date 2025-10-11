import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/profile_update_dto.dart';
import 'package:flutter_social_media/src/features/Profile/infrastructure/profile_repository.dart';

part 'profile_update_state.dart';
part 'profile_update_cubit.freezed.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  ProfileUpdateCubit() : super(const ProfileUpdateState.initial());

  Future<void> updateUserProfile({required ProfileUpdateDto dto}) async {
    emit(const ProfileUpdateState.loading());
    try {
      final bool success = await ProfileRepository().updateUserProfile(dto);

      if (success) {
        emit(const ProfileUpdateState.success());
        log('Profile updated successfully.');
      } else {
        emit(const ProfileUpdateState.error('An unknown error occurred. Failed to update profile.'));
      }
    } catch (e) {
      log('Error updating profile in cubit: $e');
      emit(ProfileUpdateState.error(e.toString()));
    }
  }
}
