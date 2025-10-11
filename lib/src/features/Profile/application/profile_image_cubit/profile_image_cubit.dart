import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

part 'profile_image_state.dart';
part 'profile_image_cubit.freezed.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit() : super(ProfileImageState.initial());

  Future<void> updateUserImage(String imagePath, {bool isCoverImage = false}) async {
    if (isCoverImage)
      emit(ProfileImageState.loadingCoverImage());
    else
      emit(ProfileImageState.loadingProfileImage());

    var currentUserId = await HiveHelper.getCurrentUserId();
    if (currentUserId == null || imagePath == '') {
      log('Image update failed: userId:$currentUserId, imagePath:$imagePath');
      return;
    }
    await AuthRepository().updateUserImage(uid: currentUserId, imagePath: imagePath, isCoverImage: isCoverImage);
    emit(ProfileImageState.success());
    log('Image updated successfully');
  }
}
