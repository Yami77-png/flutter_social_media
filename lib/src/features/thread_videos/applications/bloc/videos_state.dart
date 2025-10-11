part of 'videos_bloc.dart';

@freezed
class VideosState with _$VideosState {
  const factory VideosState.initial() = _Initial;
  const factory VideosState.videosLoading() = _VideosLoading;
  const factory VideosState.videosLoaded(List<VideoModel> videos) = _VideosLoaded;
  const factory VideosState.videosError() = _VideosError;
}
