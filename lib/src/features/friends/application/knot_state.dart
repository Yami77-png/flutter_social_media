part of 'knot_cubit.dart';

@freezed
class KnotState with _$KnotState {
  const factory KnotState.initial() = _Initial;
  const factory KnotState.loading() = _Loading;
  const factory KnotState.success() = _Success;
  const factory KnotState.cancaledRequest() = _CanceledRequest;
  const factory KnotState.rejectedRequest() = _RejectedRequest;
  const factory KnotState.accepetedRequest() = _AccepetedRequest;
  const factory KnotState.checkingKnot() = _CheckingKnots;
  const factory KnotState.hasRequestedKnot() = _HasRequestedKnots;
  const factory KnotState.hasIncomingKnot() = _HasIncomingKnots;
  const factory KnotState.isKnotted() = _IsKnotted;
  const factory KnotState.error(String message) = _Error;
}
