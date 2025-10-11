import 'dart:developer';
import 'dart:io';

import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class AudioRepository {
  final FeedRepository _feedRepository;

  AudioRepository(this._feedRepository);

  Future<AudioModel?> createAudio({
    required String title,
    required String artist,
    required String audioType,
    required File audioFile,
    required File coverImageFile,
    required PostedBy postedBy,
  }) async {
    try {
      final audioId = const Uuid().v4();

      // Convert File to XFile
      final XFile audioXFile = XFile(audioFile.path);
      final XFile coverImageXFile = XFile(coverImageFile.path);

      List<String> audioUrl = await _feedRepository.uploadPostAttachments(attachments: [audioXFile], postId: audioId);
      List<String> coverImageUrl = await _feedRepository.uploadPostAttachments(
        attachments: [coverImageXFile],
        postId: audioId,
      );

      final audio = AudioModel(
        id: audioId,
        title: title,
        artist: artist,
        type: audioType,
        postedBy: postedBy,
        audioUrl: audioUrl[0],
        coverImageUrl: coverImageUrl[0],
        tags: [],
        playCount: 0,
        uploadedAt: DateTime.now(),
      );

      await FirebaseHelper.audios.doc(audioId).set(audio.toMap());
      await FirebaseHelper.currentUserDoc.collection("audios").doc(audioId).set(audio.toMap());

      return audio;
    } catch (e) {
      log('Error creating audio: $e');
      return null;
    }
  }

  Future<List<AudioModel>> fetchAudios() async {
    try {
      final audioSnapshot = await FirebaseHelper.audios.orderBy('uploadedAt', descending: true).get();

      final currentUser = await AuthRepository().getCurrentUserData();
      final audioList = <AudioModel>[];

      for (var doc in audioSnapshot.docs) {
        final postData = doc.data() as Map<String, dynamic>;
        final audio = AudioModel.fromMap(postData);

        final reactionsSnapshot = await FirebaseHelper.audios
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

          audio.currentUserReaction = userReaction;
        }

        audioList.add(audio);
      }
      inspect(audioList);
      return audioList;
    } catch (e) {
      log('Error fetching audios: $e');
      return [];
    }
  }
}
