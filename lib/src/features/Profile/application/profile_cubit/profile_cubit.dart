import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(ProfileState.loading()) {
    getUserInfo();
  }

  final AuthRepository _authRepository;
  Future<void> getUserInfo() async {
    final user = await _authRepository.getCurrentUserData();
    if (user == null) {
      emit(ProfileState.error("Something went wrong!!"));
      return;
    }

    UserType userType = user.userType;
    IndividualProfileModel? indiProf;
    BusinessProfileModel? busiProf;
    ProfessionalProfileModel? proProf;
    ContentCreatorProfileModel? ccProf;

    switch (userType) {
      case UserType.individual:
        indiProf = await _authRepository.getIndividualUserData(refId: user.refid);
      case UserType.business:
        busiProf = await _authRepository.getBusinessUserData(refId: user.refid);
      case UserType.contentCreator:
        ccProf = await _authRepository.getContentCreatorUserData(refId: user.refid);
      case UserType.professional:
        proProf = await _authRepository.getProfessionalUserData(refId: user.refid);
    }

    emit(
      ProfileState.loaded(
        user: user,
        individualProfile: indiProf,
        businessProfile: busiProf,
        professionalProfile: proProf,
        contentCreatorProfile: ccProf,
      ),
    );
  }

  Future<void> updateUserImage(String imagePath, {bool isCoverImage = false}) async {
    var currentUserId = await HiveHelper.getCurrentUserId();
    if (currentUserId == null || imagePath == '') {
      log('Image update failed: userId:$currentUserId, imagePath:$imagePath');
      return;
    }
    await AuthRepository().updateUserImage(uid: currentUserId, imagePath: imagePath, isCoverImage: isCoverImage);
    log('Image updated successfully');

    //TODO update locally instead of calling api
    getUserInfo();
  }

  Future<void> updateUserStatus(UserStatus newStatus) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final currentUser = currentState.user;
    // final individualProfile = currentState.individual_profile;

    if (currentUser.myStatus == newStatus.name) {
      log('Status already selected.');
      return;
    }

    final updatedUserStatus = currentUser.copyWith(myStatus: newStatus.name);

    // UI update
    // emit(ProfileState.loaded(user: updatedUserStatus, individual_profile: individualProfile));

    try {
      final userRef = FirebaseHelper.users.doc(currentUser.uuid);
      await userRef.update({'myStatus': newStatus.name});
      log('STATUS UPDATED');
    } catch (e) {
      // Revert on error
      // emit(ProfileState.loaded(user: currentUser, individual_profile: individualProfile));
      log('Failed to update user status: $e');
    }
  }

  void markAsEdited(bool value) {
    final currentState = state;
    if (currentState is _Loaded) {
      emit(currentState.copyWith(personalInformationEdited: value));
    }
  }
}
