part of 'fetch_memories_cubit.dart';

@freezed
class FetchMemoriesState with _$FetchMemoriesState {
  const factory FetchMemoriesState.initial() = _Initial;
  const factory FetchMemoriesState.loading() = _Loading;
  const factory FetchMemoriesState.loaded(List<Post> memories) = _Loaded;
  const factory FetchMemoriesState.empty() = _Empty;
  const factory FetchMemoriesState.error(String message) = _Error;
}
