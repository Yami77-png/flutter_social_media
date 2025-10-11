import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/interface/i_comment_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';
import 'package:uuid/uuid.dart';

class CommentRepository implements ICommentRepository {
  @override
  Future<ReactionResult?> reactComment(String postId, String commentId, String? reactId) async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return null;

      final postRef = FirebaseHelper.posts.doc(postId);
      final commentRef = postRef.collection('comments').doc(commentId);

      final commentSnapshot = await commentRef.get();
      final commentData = commentSnapshot.data() as Map<String, dynamic>;

      final reactionsCollection = commentRef.collection('reactions');
      int reactionCount = commentData['reactionCount'] ?? 0;

      final existingReactionQuery = await reactionsCollection
          .where('reactedBy', isEqualTo: currentUser.uuid)
          .limit(1)
          .get();

      if (existingReactionQuery.docs.isNotEmpty) {
        final existingDoc = existingReactionQuery.docs.first;
        final existingData = existingDoc.data();
        final existingReaction = existingData['react'];

        if (reactId == null || reactId == existingReaction) {
          //Remove reaction
          reactionCount = (reactionCount > 0) ? reactionCount - 1 : 0;
          await existingDoc.reference.delete();
          await commentRef.update({'reactionCount': FieldValue.increment(-1)});
          log('COMMENT REACT REMOVED');
          return ReactionResult(count: reactionCount, reactionName: null);
        } else {
          //Update reaction
          await existingDoc.reference.update({'react': reactId});
          log('COMMENT REACT UPDATED');
          return ReactionResult(count: reactionCount, reactionName: reactId);
        }
      } else if (reactId != null) {
        //Add reaction
        final reactionId = const Uuid().v4();
        final reactPost = Reaction(id: reactionId, icon: '', name: reactId, reactedBy: currentUser.uuid);

        await reactionsCollection.doc(reactionId).set(reactPost.toMap());
        await commentRef.update({'reactionCount': FieldValue.increment(1)});
        log('COMMENT REACTED');
        return ReactionResult(count: reactionCount + 1, reactionName: reactId);
      }

      return ReactionResult(count: reactionCount, reactionName: null);
    } catch (e, stack) {
      log('Error liking post: $e', stackTrace: stack);
      return null;
    }
  }
}
