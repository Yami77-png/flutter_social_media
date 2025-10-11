part of 'knots_list_cubit.dart';

@freezed
class KnotsListState with _$KnotsListState {
  const factory KnotsListState.initial() = _Initial;
  const factory KnotsListState.loading() = _Loading;
  const factory KnotsListState.knotsLoaded(List<KnotModel> knots) = _KnotsLoaded;
  const factory KnotsListState.requestedKnotsLoaded(List<KnotModel> knots) = _RequestedKnotsLoaded;
  const factory KnotsListState.incomingKnotsLoaded(List<KnotModel> knots) = _IncomingKnotsLoaded;
  const factory KnotsListState.error(String message) = _Error;
}
