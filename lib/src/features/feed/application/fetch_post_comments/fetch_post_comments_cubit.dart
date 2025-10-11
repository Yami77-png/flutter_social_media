import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';

part 'fetch_post_comments_state.dart';
part 'fetch_post_comments_cubit.freezed.dart';

class FetchPostCommentsCubit extends Cubit<FetchPostCommentsState> {
  FetchPostCommentsCubit() : super(FetchPostCommentsState.initial());

  Future<void> fetchComments(String postId) async {
    emit(const FetchPostCommentsState.loading());
    try {
      List<Comment> comments = await FeedRepository().fetchCommentsForPost(postId);
      for (var comment in comments) {
        inspect(comment.toString());
      }
      emit(FetchPostCommentsState.loaded(comments));
    } catch (e) {
      emit(FetchPostCommentsState.error(e.toString()));
    }
  }
}
