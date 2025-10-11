part of 'profile_search_cubit.dart';

@freezed
class ProfileSearchState with _$ProfileSearchState {
  const factory ProfileSearchState.loading() = _Loading;
  const factory ProfileSearchState.loaded({
    required Userx user,
    required IndividualProfileModel? individualProfile,
    required BusinessProfileModel? businessProfile,
    required ContentCreatorProfileModel? contentCreatorProfile,
    required ProfessionalProfileModel? professionalProfile,
    @Default(false) bool personalInformationEdited,
  }) = _Loaded;
  const factory ProfileSearchState.error(String e) = _Error;
}
