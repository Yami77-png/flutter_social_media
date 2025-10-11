import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';

class PostBindRepository {
  Future<Post?> fetchRequestedBindPost({required String postId, required String bindedPostId}) async {
    try {
      log('Fetching requested bind post: $bindedPostId from original post: $postId');

      final docRef = FirebaseHelper.posts.doc(bindedPostId).collection('requestedBindPost').doc(postId);

      final doc = await docRef.get();

      if (!doc.exists) {
        log('Requested bind post with ID $bindedPostId does not exist.');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      final post = Post.fromJson(data);

      if (post.bindedPostId != null && post.bindedPostId!.isNotEmpty) {
        final bindedPostData = await FeedRepository().fetchPostById(post.bindedPostId!);
        if (bindedPostData != null) {
          post.bindedPost = bindedPostData;
        }
      }

      //reactions

      return post;
    } catch (e) {
      log("Error fetching requested bind post: $e");
      return null;
    }
  }

  Future<bool> rejectPostBindRequest({required String postId, required String bindedPostId}) async {
    try {
      final docRef = FirebaseHelper.posts.doc(bindedPostId).collection('requestedBindPost').doc(postId);

      await docRef.delete();

      log('Rejected post bind request');
      return true;
    } catch (e, stack) {
      log('Error rejecting post bind request: $e', stackTrace: stack);
      return false;
    }
  }

  Future<bool> acceptPostBindRequest({required Post post, required String bindedPostId}) async {
    try {
      //save to posts collection
      final docRef = FirebaseHelper.posts.doc(post.id);
      await docRef.set(post.toJson());

      //save to users collection
      final userPostRef = FirebaseHelper.users.doc(post.postedBy.id).collection("createdPosts").doc(post.id);
      await userPostRef.set(post.toJson());

      //save to sub-collection of the original post
      final bindedPostRef = FirebaseHelper.posts.doc(bindedPostId);
      final bindedPostSubCollectionRef = bindedPostRef.collection('bindedPost').doc(post.id);
      await bindedPostSubCollectionRef.set(post.toJson());

      //binding count increment on original post
      bindedPostRef.update({'bindedPostCount': FieldValue.increment(1)});

      await rejectPostBindRequest(postId: post.id, bindedPostId: bindedPostId);

      log('Accepted post bind request');
      return true;
    } catch (e, stack) {
      log('Error accepting post bind request: $e', stackTrace: stack);
      return false;
    }
  }
}
