class VoteResult {
  final int score;
  final String? userVote; // "up" | "down" | null
  VoteResult({required this.score, required this.userVote});
}
