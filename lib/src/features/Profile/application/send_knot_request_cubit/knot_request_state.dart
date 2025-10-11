part of 'knot_request_cubit.dart';

@freezed
class KnotRequestState with _$KnotRequestState {
  const factory KnotRequestState.initial() = _Initial;
  const factory KnotRequestState.sendingRequest() = _SendingRequest;
  const factory KnotRequestState.sentRequest() = _SentRequest;
  const factory KnotRequestState.error(ErrorModel error) = _Error;
}
