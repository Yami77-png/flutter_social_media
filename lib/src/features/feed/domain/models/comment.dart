import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';

// types of comment
enum CommentType { text, gif, sticker }

class Comment {
  final String id;
  final String postId;
  final String? parentId; // for nested replies
  final CommentType type;
  final String? text;
  final String? mediaUrl; // For GIF or Sticker URL
  final double? aspectRatio;
  // final List<String> likes; // userIds who liked
  final DateTime createdAt;
  //counters
  final int? reactionCount;
  final int? commentCount;
  //commenter info
  final String userId;
  final String userName;
  final String? userProfileUrl;
  //frontend only
  Reaction? currentUserReaction;

  Comment({
    required this.id,
    required this.postId,
    this.type = CommentType.text,
    required this.userId,
    required this.userName,
    this.userProfileUrl,
    this.text,
    this.mediaUrl,
    this.aspectRatio,
    // this.likes = const [],
    this.parentId,
    required this.createdAt,
    this.currentUserReaction,
    this.reactionCount = 0,
    this.commentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'text': text,
      'mediaUrl': mediaUrl,
      'aspectRatio': aspectRatio,
      // 'likes': likes,
      'parentId': parentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'reactionCount': reactionCount,
      'commentCount': commentCount,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      postId: map['postId'],
      userId: map['userId'],
      userName: map['userName'],
      userProfileUrl: map['userProfileUrl'],
      type: CommentType.values.byName(map['type'] ?? 'text'),
      text: map['text'],
      mediaUrl: map['mediaUrl'],
      aspectRatio: map['aspectRatio'],
      // likes: List<String>.from(map['likes'] ?? []),
      parentId: map['parentId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      reactionCount: map['reactionCount'],
      commentCount: map['commentCount'],
    );
  }
}
