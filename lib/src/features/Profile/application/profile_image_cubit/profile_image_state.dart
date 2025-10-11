part of 'profile_image_cubit.dart';

@freezed
class ProfileImageState with _$ProfileImageState {
  const factory ProfileImageState.initial() = _Initial;
  const factory ProfileImageState.loadingProfileImage() = _LoadingProfileImage;
  const factory ProfileImageState.loadingCoverImage() = _LoadingCoverImage;
  const factory ProfileImageState.success() = _Success;
  const factory ProfileImageState.error(String e) = _Error;
}
