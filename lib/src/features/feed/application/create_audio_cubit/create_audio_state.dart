part of 'create_audio_cubit.dart';

@freezed
class CreateAudioState with _$CreateAudioState {
  const factory CreateAudioState.initial() = _Initial;
  const factory CreateAudioState.loadding() = _Loading;
  const factory CreateAudioState.uploading({required String message}) = _Uploading;
  const factory CreateAudioState.success({required String message, required AudioModel audio}) = _Success;
  const factory CreateAudioState.error(String message) = _Error;
}
