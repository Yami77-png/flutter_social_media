part of 'videos_bloc.dart';

@freezed
class VideosEvent with _$VideosEvent {
  const factory VideosEvent.started() = _Started;
  const factory VideosEvent.fetchVideos() = _FetchVideos;
}
