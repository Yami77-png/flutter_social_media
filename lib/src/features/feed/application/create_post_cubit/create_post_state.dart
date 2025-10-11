part of 'create_post_cubit.dart';

@freezed
class CreatePostState with _$CreatePostState {
  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.uploading({required String message}) = _Uploading;
  const factory CreatePostState.success({required String message, required Post? post}) = _Success;
  const factory CreatePostState.error({required String message}) = _Error;
}
