import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';

part 'fetch_user_post_state.dart';
part 'fetch_user_post_cubit.freezed.dart';

class FetchUserPostsCubit extends Cubit<FetchUserPostsState> {
  final FeedRepository _feedRepository;

  FetchUserPostsCubit(this._feedRepository) : super(const FetchUserPostsState.initial());

  Future<void> fetchPosts(String userId) async {
    emit(const FetchUserPostsState.loading());
    try {
      final List<Post> posts = await _feedRepository.fetchUserPosts(userId);

      if (posts.isNotEmpty) {
        emit(FetchUserPostsState.loaded(posts));
      } else {
        emit(const FetchUserPostsState.empty());
      }
    } catch (e) {
      log('Error in FetchUserPostsCubit: $e');
      emit(FetchUserPostsState.error('Failed to load posts. Please try again.'));
    }
  }
}
