import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/audio_repository.dart';

part 'fetch_audios_state.dart';
part 'fetch_audios_cubit.freezed.dart';

class FetchAudiosCubit extends Cubit<FetchAudiosState> {
  final AudioRepository _audioRepository;

  FetchAudiosCubit(this._audioRepository) : super(const FetchAudiosState.initial()) {
    fetchAudios();
  }

  Future<void> fetchAudios() async {
    emit(const FetchAudiosState.loading());
    try {
      final audios = await _audioRepository.fetchAudios();

      if (audios.isNotEmpty) {
        emit(FetchAudiosState.loaded(audios));
      } else {
        emit(const FetchAudiosState.empty());
      }
    } catch (e) {
      emit(const FetchAudiosState.error('Failed to load audio feed.'));
    }
  }

  void addAudioAtTop(AudioModel audio) {
    if (state is _Loaded) {
      final current = (state as _Loaded).audios;
      emit(FetchAudiosState.loaded([audio, ...current]));
    }
  }
}
