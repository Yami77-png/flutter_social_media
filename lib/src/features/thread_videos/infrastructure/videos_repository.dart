import 'dart:developer';

import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/video_model.dart';

class VideosRepository {
  Future<List<VideoModel>> fetchVideos() async {
    try {
      final postSnapshot = await FirebaseHelper.videos.orderBy('uploadedAt', descending: true).get();

      final currentUser = await AuthRepository().getCurrentUserData();
      final postList = <VideoModel>[];

      for (var doc in postSnapshot.docs) {
        final postData = doc.data() as Map<String, dynamic>;
        final video = VideoModel.fromMap(postData);

        final reactionsSnapshot = await FirebaseHelper.posts
            .doc(doc.id)
            .collection('reactions')
            .where('reactedBy', isEqualTo: currentUser!.uuid)
            .get();

        if (reactionsSnapshot.docs.isNotEmpty) {
          final reactionReactId = reactionsSnapshot.docs.first.data()['react'];

          final userReaction = reactions.firstWhere(
            (r) => r.id == reactionReactId,
            orElse: () => Reaction(id: 'react-0', icon: '', name: ''),
          );

          video.currentUserReaction = userReaction;
        }

        postList.add(video);
      }
      inspect(postList);
      return postList;
    } catch (e) {
      log('Error fetching posts: $e');
      return [];
    }
  }
}
