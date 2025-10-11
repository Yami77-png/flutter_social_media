part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded({
    required Userx user,
    required IndividualProfileModel? individualProfile,
    required BusinessProfileModel? businessProfile,
    required ContentCreatorProfileModel? contentCreatorProfile,
    required ProfessionalProfileModel? professionalProfile,
    @Default(false) bool personalInformationEdited,
  }) = _Loaded;
  const factory ProfileState.error(String e) = _Error;
}
