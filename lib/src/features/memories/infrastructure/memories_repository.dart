import 'dart:developer';
import 'dart:io';
import 'package:flutter_social_media/src/features/feed/application/like_cubit/like_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart'; // Import XFile
import '../domain/interface/i_memories_repository.dart';

@LazySingleton(as: IMemoriesRepository)
class MemoriesRepository implements IMemoriesRepository {
  final FeedRepository _feedRepository;

  MemoriesRepository(this._feedRepository);

  @override
  Future<Post?> createMemory({
    required PostedBy postedBy,
    String? caption,
    required List<File> attachments,
    List<String>? tags,
    PostPrivacy privacy = PostPrivacy.PUBLIC,
    required int timePeriodInHour,
  }) async {
    try {
      final memoryId = const Uuid().v4();
      final refId = const Uuid().v4();

      // Convert List<File> to List<XFile>
      final List<XFile> xFileAttachments = attachments.map((file) => XFile(file.path)).toList();

      // Upload attachments
      final attachmentUrls = xFileAttachments.isNotEmpty
          ? await _feedRepository.uploadPostAttachments(attachments: xFileAttachments, postId: memoryId)
          : <String>[];

      final memory = Post(
        refId: refId,
        privacy: privacy,
        id: memoryId,
        postedBy: postedBy,
        postedAt: DateTime.now().toIso8601String(),
        caption: caption,
        attachment: attachmentUrls,
        upvotes: 0,
        downvotes: 0,
        commentCount: 0,
        tags: tags ?? [],
        timePeriodInHour: timePeriodInHour,
        userVote: VoteType.none,
      );

      // Save to Firestore
      await FirebaseHelper.memories.doc(memoryId).set(memory.toJson());
      await FirebaseHelper.currentUserDoc.collection('createdMemories').doc(memoryId).set(memory.toJson());

      return memory;
    } catch (e) {
      log('Error creating memory: $e');
      return null;
    }
  }

  @override
  Future<List<Post>> fetchMemories() async {
    try {
      final memoriesSnapshot = await FirebaseHelper.memories.orderBy('postedAt', descending: true).get();
      final currentUserId = await HiveHelper.getCurrentUserId();
      final memories = <Post>[];

      for (var doc in memoriesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final memory = Post.fromJson(data);

        // Fetch current user's vote
        final votesSnapshot = await FirebaseHelper.memories
            .doc(doc.id)
            .collection('votes')
            .where('votedBy', isEqualTo: currentUserId)
            .limit(1)
            .get();

        if (votesSnapshot.docs.isNotEmpty) {
          final voteStr = votesSnapshot.docs.first.data()['vote'] as String?;
          memory.userVote = VoteType.values.firstWhere((v) => v.name == voteStr, orElse: () => VoteType.none);
        }

        memories.add(memory);
      }

      log('Successfully fetched ${memories.length} memories.');
      return memories;
    } catch (e) {
      log('Error fetching memories: $e');
      return [];
    }
  }
}
