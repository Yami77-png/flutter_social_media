import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/comment_repository.dart';

part 'like_comment_state.dart';
part 'like_comment_cubit.freezed.dart';

class LikeCommentCubit extends Cubit<LikeCommentState> {
  LikeCommentCubit({int initialCount = 0, String? initialReaction})
    : super(LikeCommentState.initial(count: initialCount, reaction: initialReaction));

  Future<void> reactComment(String postId, String commentId, String? reactId) async {
    final prevState = state;

    final isRemoving = (state.reaction != null && (reactId == null || reactId == state.reaction));
    final isUpdating = (state.reaction != null && reactId != null && reactId != state.reaction);
    final isAdding = (state.reaction == null && reactId != null);

    // UI update instantly
    if (isRemoving) {
      emit(state.copyWith(count: (state.count > 0 ? state.count - 1 : 0), reaction: null));
    } else if (isUpdating) {
      emit(state.copyWith(reaction: reactId));
    } else if (isAdding) {
      emit(state.copyWith(count: state.count + 1, reaction: reactId));
    }

    // Backend update
    final result = await CommentRepository().reactComment(postId, commentId, reactId);

    if (result != null) {
      emit(LikeCommentState.updated(count: result.count, reaction: result.reactionName));
    } else {
      //Error: revert ui update
      emit(prevState);
      log('Reaction update failed. UI reverted.');
    }
  }
}
