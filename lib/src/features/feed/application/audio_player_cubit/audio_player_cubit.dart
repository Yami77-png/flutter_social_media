// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';

// part 'audio_player_state.dart';
// part 'audio_player_cubit.freezed.dart';

// class AudioPlayerCubit extends Cubit<AudioPlayerState> {
//   final AudioPlayer _audioPlayer;
//   StreamSubscription? _playerStateSubscription;
//   String? _currentAudioId;

//   AudioPlayerCubit() : _audioPlayer = AudioPlayer(), super(const AudioPlayerState.initial()) {
//     // Listen to the player's internal state to emit our own cubit states
//     _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         _audioPlayer.seek(Duration.zero);
//         _audioPlayer.pause();
//         emit(const AudioPlayerState.initial());
//       }
//     });
//   }

//   /// Plays a given audio track.
//   /// If it's a new track, it loads it first. If it's the current track, it resumes.
//   Future<void> play(AudioModel audio) async {
//     try {
//       // If user taps a different audio, load the new source
//       if (_currentAudioId != audio.id) {
//         emit(AudioPlayerState.loading(audio.id));
//         _currentAudioId = audio.id;
//         await _audioPlayer.setUrl(audio.audioUrl);
//       }
//       // Play the audio
//       await _audioPlayer.play();
//       emit(AudioPlayerState.playing(audio.id));
//     } catch (e) {
//       // Handle errors
//       emit(const AudioPlayerState.initial());
//     }
//   }

//   /// Pauses the currently playing audio.
//   Future<void> pause() async {
//     await _audioPlayer.pause();
//     if (_currentAudioId != null) {
//       emit(AudioPlayerState.paused(_currentAudioId!));
//     }
//   }

//   /// Stops playback completely.
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     emit(const AudioPlayerState.initial());
//   }

//   @override
//   Future<void> close() {
//     _playerStateSubscription?.cancel();
//     _audioPlayer.dispose();
//     return super.close();
//   }
// }
