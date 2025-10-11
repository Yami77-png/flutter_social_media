import 'package:freezed_annotation/freezed_annotation.dart';
import 'like_cubit.dart';

part 'like_state.freezed.dart';

@freezed
abstract class LikeState with _$LikeState {
  const factory LikeState({required int score, required VoteType vote, required bool isLoading}) = _LikeState;

  factory LikeState.initial() => const LikeState(score: 0, vote: VoteType.none, isLoading: true);
}
