part of 'post_bind_cubit.dart';

@freezed
class PostBindState with _$PostBindState {
  const factory PostBindState.initial() = _Initial;
  const factory PostBindState.loading() = _Loading;
  const factory PostBindState.rejectedRequest() = _RejectedRequest;
  const factory PostBindState.accepetedRequest() = _AccepetedRequest;
  const factory PostBindState.error(String message) = _Error;
}
