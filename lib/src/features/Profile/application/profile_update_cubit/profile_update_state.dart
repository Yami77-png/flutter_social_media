part of 'profile_update_cubit.dart';

@freezed
class ProfileUpdateState with _$ProfileUpdateState {
  const factory ProfileUpdateState.initial() = _Initial;
  const factory ProfileUpdateState.loading() = _Loading;
  const factory ProfileUpdateState.success() = _Success;
  const factory ProfileUpdateState.error(String message) = _Error;
}
