import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user_profile_args.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

part 'profile_search_state.dart';
part 'profile_search_cubit.freezed.dart';

class ProfileSearchCubit extends Cubit<ProfileSearchState> {
  ProfileSearchCubit(this._authRepository) : super(ProfileSearchState.loading());

  final AuthRepository _authRepository;
  Future<UserProfileArgs?> getSearchUserInfo(String uuid) async {
    try {
      emit(ProfileSearchState.loading());
      final user = await _authRepository.getUserDataByUuid(uuid);

      if (user == null) {
        emit(ProfileSearchState.error("Something went wrong!!"));
        return null;
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
        ProfileSearchState.loaded(
          user: user,
          individualProfile: indiProf,
          businessProfile: busiProf,
          professionalProfile: proProf,
          contentCreatorProfile: ccProf,
        ),
      );
      return UserProfileArgs(
        user: user,
        individualProfile: indiProf,
        businessProfile: busiProf,
        professionalProfile: proProf,
        contentCreatorProfile: ccProf,
      );
    } catch (e) {
      log('Error fetching user info for cubit: $e');
      emit(ProfileSearchState.error(e.toString()));
      return null;
    }
  }
}
