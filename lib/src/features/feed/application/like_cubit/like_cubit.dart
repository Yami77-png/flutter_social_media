import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'like_state.dart';

enum VoteType { none, up, down }

class LikeCubit extends Cubit<LikeState> {
  final FeedRepository _repo;
  final AuthRepository _auth;

  LikeCubit(this._repo, this._auth) : super(LikeState.initial());

  late String _postId;
  late String _userId;

  Future<void> init(String postId) async {
    _postId = postId;
    final user = await _auth.getCurrentUserData();
    if (user == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    _userId = user.uuid;

    final result = await _repo.fetchVoteState(postId: _postId, userId: _userId);
    if (result != null) {
      emit(state.copyWith(score: result.score, vote: _mapVote(result.userVote), isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> vote(VoteType newVote) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repo.votePost(postId: _postId, userId: _userId, vote: newVote);
    if (result != null) {
      emit(state.copyWith(score: result.score, vote: _mapVote(result.userVote), isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  VoteType _mapVote(String? vote) {
    switch (vote) {
      case "up":
        return VoteType.up;
      case "down":
        return VoteType.down;
      default:
        return VoteType.none;
    }
  }
}
