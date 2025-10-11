part of 'profile_pic_privacy_cubit.dart';

@freezed
class ProfilePicPrivacyState with _$ProfilePicPrivacyState {
  const factory ProfilePicPrivacyState.initial() = _Initial;
  const factory ProfilePicPrivacyState.loading() = _Loading;
  const factory ProfilePicPrivacyState.success(ProfilePicturePrivacy privacy, UserType userType) = _Success;
  const factory ProfilePicPrivacyState.error(String message) = _Error;
}
