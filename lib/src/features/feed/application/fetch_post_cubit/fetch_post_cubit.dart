import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_social_media/src/features/feed/domain/interface/i_feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';

part 'fetch_post_state.dart';
part 'fetch_post_cubit.freezed.dart';

@injectable
class FetchPostCubit extends Cubit<FetchPostState> {
  FetchPostCubit(this._feedRepository) : super(FetchPostState.loading()) {
    fetchCachedPosts();
  }
  final IFeedRepository _feedRepository;

  Future<void> fetchPost({bool cacheLoaded = false}) async {
    if (!cacheLoaded) {
      emit(FetchPostState.loading());
    }

    final connectivityResult = await Connectivity().checkConnectivity();

    final isOnline = !connectivityResult.contains(ConnectivityResult.none);

    log(isOnline ? 'Device Online' : 'Device Offline');

    if (isOnline) {
      try {
        List<Post> data = await _feedRepository.fetchPosts();

        if (data.isNotEmpty) {
          emit(FetchPostState.loaded(data));
        } else {
          log('Offline mode - reading from Hive');
          final cachedData = await _feedRepository.getPostsFromHive();
          if (cachedData.isNotEmpty) {
            emit(FetchPostState.loaded(cachedData));
          } else {
            emit(FetchPostState.error());
          }
        }
      } catch (e) {
        log('Offline mode - reading from Hive');
        final cachedData = await _feedRepository.getPostsFromHive();
        if (cachedData.isNotEmpty) {
          emit(FetchPostState.loaded(cachedData));
        } else {
          emit(FetchPostState.error());
        }
      }
    } else {
      log('Offline mode - reading from Hive');
      final cachedData = await _feedRepository.getPostsFromHive();
      if (cachedData.isNotEmpty) {
        emit(FetchPostState.loaded(cachedData));
      } else {
        emit(FetchPostState.error());
      }
    }
  }

  Future<void> fetchCachedPosts() async {
    emit(FetchPostState.loading());

    final cachedData = await _feedRepository.getPostsFromHive();
    if (cachedData.isNotEmpty) {
      emit(FetchPostState.loaded(cachedData));
      fetchPost(cacheLoaded: true);
    } else {
      fetchPost();
    }
  }
}
