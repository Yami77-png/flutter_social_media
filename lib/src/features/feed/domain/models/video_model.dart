import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  String thumbnailUrl;
  PostedBy postedBy;
  final DateTime uploadedAt;
  final int viewCount;
  final List<String> tags;
  Reaction? currentUserReaction;
  final int? reactionCount;
  final int? commentCount;

  VideoModel({
    required this.postedBy,
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.uploadedAt,
    required this.viewCount,
    required this.tags,
    this.reactionCount = 0,
    this.commentCount = 0,
    this.currentUserReaction,
  });

  Map<String, dynamic> toMap() {
    return {
      'reactionCount': reactionCount,
      'commentCount': commentCount,
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'postedBy': postedBy.toMap(),
      'uploadedAt': uploadedAt.toIso8601String(),
      'viewCount': viewCount,
      'tags': tags,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      videoUrl: map['videoUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      postedBy: PostedBy.fromMap(map['postedBy']),
      uploadedAt: DateTime.parse(map['uploadedAt']),
      viewCount: map['viewCount'],
      tags: List<String>.from(map['tags']),
    );
  }
}
