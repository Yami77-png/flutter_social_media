part of 'fetch_audios_cubit.dart';

@freezed
class FetchAudiosState with _$FetchAudiosState {
  const factory FetchAudiosState.initial() = _Initial;
  const factory FetchAudiosState.loading() = _Loading;
  const factory FetchAudiosState.loaded(List<AudioModel> audios) = _Loaded;
  const factory FetchAudiosState.empty() = _Empty;
  const factory FetchAudiosState.error(String message) = _Error;
}
