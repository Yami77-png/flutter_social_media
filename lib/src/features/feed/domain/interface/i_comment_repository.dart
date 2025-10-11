import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';

abstract class ICommentRepository {
  Future<ReactionResult?> reactComment(String postId, String commentId, String? reactId);
}
