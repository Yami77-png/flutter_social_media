part of 'like_comment_cubit.dart';

@freezed
abstract class LikeCommentState with _$LikeCommentState {
  const factory LikeCommentState.initial({@Default(0) int count, String? reaction}) = _Initial;

  const factory LikeCommentState.updated({required int count, String? reaction}) = _Updated;
}
