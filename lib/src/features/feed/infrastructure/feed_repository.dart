import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/services/notification_services.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/interface/i_feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/hive_post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as path;

import '../application/like_cubit/like_cubit.dart';
import '../domain/models/vote_result.dart';

@LazySingleton(as: IFeedRepository)
class FeedRepository implements IFeedRepository {
  final firestore = FirebaseFirestore.instance;

  /// Fetch posts from Hive local cache
  @override
  Future<List<Post>> getPostsFromHive() async {
    final box = await Hive.openBox<HivePost>('posts');
    final posts = box.values.map((e) => e.toPost()).toList();

    posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return posts;
  }

  /// Fetch posts from Firestore and cache in Hive
  @override
  Future<List<Post>> fetchPosts() async {
    try {
      final snapshot = await FirebaseHelper.posts.orderBy('postedAt', descending: true).get();
      final posts = await _processPostSnapshot(snapshot);

      // Cache to Hive
      final box = await Hive.openBox<HivePost>('posts');
      await box.clear();
      for (var post in posts) {
        await box.put(post.id, HivePost.fromPost(post));
      }

      log('Fetched and cached ${posts.length} posts.');
      return posts;
    } catch (e, stack) {
      log('Error fetching posts: $e', stackTrace: stack);
      return [];
    }
  }

  Future<List<Post>> fetchUserPosts(String userId) async {
    try {
      final postSnapshot = await FirebaseHelper.users
          .doc(userId)
          .collection('createdPosts')
          .orderBy('postedAt', descending: true)
          .get();

      final postList = await _processPostSnapshot(postSnapshot);

      log('Successfully fetched ${postList.length} posts for the user $userId');
      return postList;
    } catch (e) {
      log('Error fetching posts: $e');
      return [];
    }
  }

  /// Fetch single post by ID
  Future<Post?> fetchPostById(String postId) async {
    try {
      final doc = await FirebaseHelper.posts.doc(postId).get();
      if (!doc.exists) return null;

      var post = Post.fromJson(doc.data() as Map<String, dynamic>);
      final currentUser = await AuthRepository().getCurrentUserData();

      // Get current user's vote
      if (currentUser != null) {
        final voteSnap = await FirebaseHelper.posts
            .doc(postId)
            .collection('votes')
            .where('votedBy', isEqualTo: currentUser.uuid)
            .limit(1)
            .get();

        if (voteSnap.docs.isNotEmpty) {
          final vote = voteSnap.docs.first.data()['vote'] as String?;
          if (vote == 'up') post = post.copyWith(userVote: VoteType.up);
          if (vote == 'down') post = post.copyWith(userVote: VoteType.down);
        }
      }

      return post;
    } catch (e, stack) {
      log('Error fetching post $postId: $e', stackTrace: stack);
      return null;
    }
  }

  Future<void> updatePostedByInfo({
    required String postId,
    required String newName,
    required String newImageUrl,
  }) async {
    try {
      final postRef = FirebaseHelper.posts.doc(postId);
      await postRef.update({'postedBy.name': newName, 'postedBy.imageUrl': newImageUrl});
      log('Updated postedBy info for post: $postId');
    } catch (e) {
      log('Error updating postedBy info: $e');
    }
  }

  /// Process Firestore snapshot into Post objects
  Future<List<Post>> _processPostSnapshot(QuerySnapshot snapshot) async {
    final postList = <Post>[];
    final currentUser = await AuthRepository().getCurrentUserData();

    for (var doc in snapshot.docs) {
      var post = Post.fromJson(doc.data() as Map<String, dynamic>);

      // Fetch binded post if exists
      if (post.bindedPostId != null && post.bindedPostId!.isNotEmpty) {
        final binded = await fetchPostById(post.bindedPostId!);
        if (binded != null) post = post.copyWith(bindedPost: binded);
      }

      // Fetch current user's vote
      if (currentUser != null) {
        final voteSnap = await FirebaseHelper.posts
            .doc(post.id)
            .collection('votes')
            .where('votedBy', isEqualTo: currentUser.uuid)
            .limit(1)
            .get();

        if (voteSnap.docs.isNotEmpty) {
          final vote = voteSnap.docs.first.data()['vote'] as String?;
          if (vote == 'up') post = post.copyWith(userVote: VoteType.up);
          if (vote == 'down') post = post.copyWith(userVote: VoteType.down);
        }
      }

      postList.add(post);
    }

    return postList;
  }

  /// Create a new post
  @override
  Future<Post?> createPost({
    required PostedBy postedBy,
    String? caption,
    List<File>? attachments, // <-- Remains List<File>?
    List<String>? tags,
    bool isVideo = false,
    bool isAudio = false,
    PostPrivacy privacy = PostPrivacy.PUBLIC,
    Post? bindedPost,
  }) async {
    try {
      final postId = const Uuid().v4();
      final refId = const Uuid().v4();

      List<String> attachmentUrls = [];
      if (attachments != null && attachments.isNotEmpty) {
        // Convert List<File> to List<XFile>
        final List<XFile> xFiles = attachments.map((file) => XFile(file.path)).toList();
        attachmentUrls = await uploadPostAttachments(attachments: xFiles, postId: postId); // Pass the converted list
      }

      final post = Post(
        refId: refId,
        isVideo: isVideo,
        isAudio: isAudio,
        privacy: bindedPost?.privacy ?? privacy,
        id: postId,
        postedBy: postedBy,
        postedAt: DateTime.now().toIso8601String(),
        caption: caption,
        attachment: attachmentUrls,
        upvotes: 0,
        downvotes: 0,
        commentCount: 0,
        tags: tags ?? [],
        bindedPostId: bindedPost?.id,
        bindedPost: bindedPost,
      );

      // Store in Firestore
      await FirebaseHelper.posts.doc(postId).set(post.toJson());
      await FirebaseHelper.currentUserDoc.collection("createdPosts").doc(postId).set(post.toJson());

      // Cache in Hive
      final box = await Hive.openBox<HivePost>('posts');
      await box.put(post.id, HivePost.fromPost(post));

      return post;
    } catch (e, stack) {
      log('Error creating post: $e', stackTrace: stack);
      return null;
    }
  }

  Future<void> _bindedPost(Post bindedPost, Post post) async {
    final bindedPostRef = FirebaseHelper.posts.doc(bindedPost.id);
    if (bindedPost.privacy == PostPrivacy.PUBLIC) {
      //bind count++ for binded post
      await bindedPostRef.update({'bindedPostCount': FieldValue.increment(1)});

      //store new post on bindedPost sub-collection
      final bindedPostSubCollectionRef = bindedPostRef.collection('bindedPost').doc(post.id);
      await bindedPostSubCollectionRef.set(post.toJson());
    } else {
      //store new post on requestedBindPost sub-collection
      final requestedBindPostSubCollectionRef = bindedPostRef.collection('requestedBindPost').doc(post.id);
      await requestedBindPostSubCollectionRef.set(post.toJson());
    }

    //notification
    final bool isGlobal = bindedPost.privacy == PostPrivacy.PUBLIC;
    await NotificationServices().sendNotification(
      receiverUid: bindedPost.postedBy.id,
      type: isGlobal ? NotificationType.bindPost : NotificationType.bindPostRequest,
      payload: NotificationPayload(
        title: '${post.postedBy.name} has ${isGlobal ? 'bound your post.' : 'requested to bind your post.'}',
        body: '${bindedPost.caption}',
        image: post.postedBy.imageUrl,
        postId: post.id,
        bindedPostId: bindedPost.id,
      ),
    );
  }

  /// Upload attachments (image/video) with compression
  Future<List<String>> uploadPostAttachments({
    required List<XFile> attachments,
    required String postId,
    bool useEmulator = true, // Set true for emulator
  }) async {
    final List<String> attachmentUrls = [];
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Use emulator if requested
    if (useEmulator) {
      storage.useStorageEmulator('192.168.0.171', 9199);
    }

    for (XFile xfile in attachments) {
      final ext = path.extension(xfile.path).replaceFirst('.', '').toLowerCase();
      final isVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);
      final isImage = ['jpg', 'jpeg', 'png'].contains(ext);

      // Convert XFile to File
      File fileToUpload = File(xfile.path);

      // Compress if needed
      if (isVideo) {
        final info = await VideoCompress.compressVideo(
          xfile.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
        );
        if (info?.file != null) fileToUpload = info!.file!;
      } else if (isImage) {
        final dir = await getTemporaryDirectory();
        final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.$ext');

        final compressedFile = await FlutterImageCompress.compressAndGetFile(xfile.path, targetPath, quality: 80);

        if (compressedFile != null) {
          fileToUpload = File(compressedFile.path);
        }
      }

      // Prepare storage reference
      final folder = isVideo ? 'posts/videos' : 'posts/images';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final ref = storage.ref().child('$folder/$postId/$fileName');

      try {
        final snapshot = await ref.putFile(fileToUpload).whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        attachmentUrls.add(downloadUrl);
      } catch (e) {
        log('Failed to upload file $fileName: $e');
      }
    }

    return attachmentUrls;
  }

  Future<bool> addCommentToPost({
    required String postId,
    String? commentText,
    String? parentCommentId,
    required String notificationReceiverId,
    required CommentType type,
    String? mediaUrl,
    double? aspectRatio,
  }) async {
    try {
      final commentId = const Uuid().v4();
      var currentUser = await AuthRepository().getCurrentUserData();
      final comment = Comment(
        postId: postId,
        id: commentId,
        type: type,
        text: commentText,
        mediaUrl: mediaUrl,
        aspectRatio: aspectRatio,
        userId: currentUser!.uuid,
        userName: currentUser.name,
        userProfileUrl: currentUser.imageUrl,
        createdAt: DateTime.now(),
        parentId: parentCommentId,
      );

      final postRef = FirebaseHelper.posts.doc(postId);

      final commentsRef = postRef.collection('comments').doc(commentId);

      await commentsRef.set(comment.toMap());
      await postRef.update({'commentCount': FieldValue.increment(1)});
      if (parentCommentId != null) {
        final parentCommentsRef = postRef.collection('comments').doc(parentCommentId);
        await parentCommentsRef.update({'commentCount': FieldValue.increment(1)});
      }

      //Notification
      String notificationBody;
      if (commentText != null && commentText.isNotEmpty) {
        notificationBody = commentText;
      } else if (type == CommentType.gif) {
        notificationBody = 'sent a GIF';
      } else if (type == CommentType.sticker) {
        notificationBody = 'sent a sticker';
      } else {
        notificationBody = 'commented on your post';
      }

      await NotificationServices().sendNotification(
        receiverUid: notificationReceiverId,
        type: NotificationType.comment,
        payload: NotificationPayload(
          title: '${currentUser.name} $notificationBody',
          body: commentText ?? '',
          image: currentUser.imageUrl,
          postId: postId,
        ),
      );
      log(parentCommentId == null ? 'comment posted to $postId' : 'Replied to comment $parentCommentId');
      return true;
    } catch (e, stack) {
      log('Failed to add comment', error: e, stackTrace: stack);
      return false;
    }
  }

  Future<List<Comment>> fetchCommentsForPost(String postId) async {
    try {
      final postRef = FirebaseHelper.posts.doc(postId);
      final snapshot = await postRef
          .collection('comments')
          // .where('parentId', isEqualTo: null) //base comments only
          .orderBy('createdAt', descending: false)
          .get();

      final currentUser = await AuthRepository().getCurrentUserData();
      final commentList = <Comment>[];

      for (var doc in snapshot.docs) {
        final postData = doc.data();
        final post = Comment.fromMap(postData);

        final reactionsSnapshot = await postRef
            .collection('comments')
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

          post.currentUserReaction = userReaction;
        }

        commentList.add(post);
      }

      return commentList;
      // return snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<VoteResult?> votePost({required String postId, required VoteType vote, required String userId}) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final voteRef = postRef.collection('votes').doc(userId);

    try {
      final postSnap = await postRef.get();
      if (!postSnap.exists) return null;

      int score = (postSnap.data()?['score'] ?? 0) as int;

      final voteSnap = await voteRef.get();
      String? prevVote = voteSnap.exists ? voteSnap['vote'] as String? : null;

      // Remove previous vote effect
      if (prevVote == 'up') score -= 1;
      if (prevVote == 'down') score += 1;

      String? appliedVote;
      if (vote == VoteType.none) {
        if (voteSnap.exists) await voteRef.delete();
        appliedVote = null;
      } else {
        await voteRef.set({'vote': vote.name});
        if (vote == VoteType.up) score += 1;
        if (vote == VoteType.down) score -= 1;
        appliedVote = vote.name;
      }

      await postRef.update({'score': score});

      return VoteResult(score: score, userVote: appliedVote);
    } catch (e, st) {
      print("Error voting post: $e");
      print(st);
      return null;
    }
  }

  Future<VoteResult?> fetchVoteState({required String postId, required String userId}) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final postSnap = await postRef.get();
    if (!postSnap.exists) return null;

    final score = (postSnap.data()?['score'] ?? 0) as int;

    final voteSnap = await postRef.collection('votes').doc(userId).get();
    final userVote = voteSnap.exists ? (voteSnap.data()?['vote'] as String?) : null;

    return VoteResult(score: score, userVote: userVote);
  }
}
