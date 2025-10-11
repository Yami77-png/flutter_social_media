part of 'create_memories_cubit.dart';

@freezed
class CreateMemoriesState with _$CreateMemoriesState {
  const factory CreateMemoriesState.initial() = _Initial;
  const factory CreateMemoriesState.uploading({required String message}) = _Uploading;
  const factory CreateMemoriesState.success({required String message, required Post? memory}) = _Success;
  const factory CreateMemoriesState.error({required String message}) = _Error;
}
