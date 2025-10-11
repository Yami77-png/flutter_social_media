import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/video_model.dart';
import 'package:flutter_social_media/src/features/thread_videos/infrastructure/videos_repository.dart';

part 'videos_event.dart';
part 'videos_state.dart';
part 'videos_bloc.freezed.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc() : super(_Initial()) {
    on<VideosEvent>((event, emit) async {
      await event.map(
        started: (e) {},
        fetchVideos: (e) async {
          return await fetchVideos(emit);
        },
      );
    });
  }

  Future<void> fetchVideos(Emitter<VideosState> emit) async {
    try {
      emit(VideosState.videosLoading());

      final result = await VideosRepository().fetchVideos();
      List<VideoModel> videos = [];
      if (result.isNotEmpty) {
        for (var video in result) {
          if (video.thumbnailUrl.isEmpty) {
            // final generated = await Helpers.generateThumbnail(video.videoUrl, video.id);
            // if (generated != null) {
            //   video.thumbnailUrl = generated;
            //   videos.add(video);
            //   log("Video thumbnail: ${video.thumbnailUrl}");
            // }
          }
        }
        inspect(videos);
        emit(VideosState.videosLoaded(videos));
      } else {
        emit(VideosState.videosError());
      }
    } catch (e, stack) {
      // Optionally log or inspect
      log('Error fetching videos: $e\n$stack');
      emit(VideosState.videosError());
    }
  }
}
