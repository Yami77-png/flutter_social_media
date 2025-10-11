part of 'fetch_user_post_cubit.dart';

@freezed
class FetchUserPostsState with _$FetchUserPostsState {
  const factory FetchUserPostsState.initial() = _Initial;
  const factory FetchUserPostsState.loading() = _Loading;
  const factory FetchUserPostsState.loaded(List<Post> posts) = _Loaded;
  const factory FetchUserPostsState.empty() = _Empty;
  const factory FetchUserPostsState.error(String message) = _Error;
}
