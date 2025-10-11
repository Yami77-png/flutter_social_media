part of 'profile_pic_cubit.dart';

@freezed
class ProfilePicState with _$ProfilePicState {
  const factory ProfilePicState.loading() = _Loading;
  const factory ProfilePicState.loaded(Userx user) = _Loaded;
  const factory ProfilePicState.error(String e) = _Error;
}
