part of 'rest_password_cubit.dart';

@freezed
class RestPasswordState with _$RestPasswordState {
  const factory RestPasswordState.initial() = _Initial;
  const factory RestPasswordState.loading() = _Loading;
  const factory RestPasswordState.success() = _Success;
  const factory RestPasswordState.failure(String message) = _Failure;
}
