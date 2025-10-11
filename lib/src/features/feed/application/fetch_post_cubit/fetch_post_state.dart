part of 'fetch_post_cubit.dart';

@freezed
class FetchPostState with _$FetchPostState {
  const factory FetchPostState.loading() = _Loading;
  const factory FetchPostState.loaded(List<Post> posts) = _Loaded;
  const factory FetchPostState.error() = _Error;
}
