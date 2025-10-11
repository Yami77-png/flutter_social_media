import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/audio_repository.dart';

part 'create_audio_state.dart';
part 'create_audio_cubit.freezed.dart';

class CreateAudioCubit extends Cubit<CreateAudioState> {
  CreateAudioCubit(this._audioRepository) : super(CreateAudioState.initial());
  final AudioRepository _audioRepository;

  Future<void> createAudio({
    required String title,
    required String artist,
    required String audioType,
    required File audioFile,
    required File coverImageFile,
  }) async {
    // emit(CreateAudioState.loadding());
    emit(const CreateAudioState.uploading(message: 'Publishing your audio...'));
    final result = await AuthRepository().getCurrentUserData();
    if (result == null) {
      emit(const CreateAudioState.error('User not found. Please log in again.'));
      return;
    }

    final postedby = PostedBy(id: result.uuid, name: result.name, imageUrl: result.imageUrl);
    final audio = await _audioRepository.createAudio(
      postedBy: postedby,
      title: title,
      artist: artist,
      audioType: audioType,
      audioFile: audioFile,
      coverImageFile: coverImageFile,
    );
    if (audio != null) {
      emit(CreateAudioState.success(message: 'Audio published successfully!', audio: audio));
    } else {
      emit(CreateAudioState.error('Failed to upload audio.'));
    }
  }

  void clearState() {
    emit(const CreateAudioState.initial());
  }
}
