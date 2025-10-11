import 'dart:io';

import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';

abstract class IFeedRepository {
  Future<List<Post>> fetchPosts();
  Future<List<Post>> getPostsFromHive();
  Future<Post?> createPost({
    required PostedBy postedBy,
    String? caption,
    List<File>? attachments,
    List<String>? tags,
    bool isVideo = false,
    bool isAudio = false,
    PostPrivacy privacy = PostPrivacy.PUBLIC,
    Post? bindedPost,
  });
}
