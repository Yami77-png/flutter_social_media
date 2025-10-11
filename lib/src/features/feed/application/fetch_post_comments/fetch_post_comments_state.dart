part of 'fetch_post_comments_cubit.dart';

@freezed
class FetchPostCommentsState with _$FetchPostCommentsState {
  const factory FetchPostCommentsState.initial() = _Initial;
  const factory FetchPostCommentsState.loading() = _Loading;
  const factory FetchPostCommentsState.loaded(List<Comment> comments) = _Loaded;
  const factory FetchPostCommentsState.error(String message) = _Error;
}
