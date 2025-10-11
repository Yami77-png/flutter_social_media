import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/reaction.dart';

enum AudioType { song, voice, podcast }

class AudioModel {
  final String id;
  final String title;
  final String artist;
  final String type;
  final String audioUrl;
  String coverImageUrl;
  PostedBy postedBy;
  final DateTime uploadedAt;
  final int playCount;
  final List<String> tags;
  Reaction? currentUserReaction;
  final int? reactionCount;
  final int? commentCount;

  AudioModel({
    required this.postedBy,
    required this.id,
    required this.title,
    required this.artist,
    required this.type,
    required this.audioUrl,
    required this.coverImageUrl,
    required this.uploadedAt,
    required this.playCount,
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
      'artist': artist,
      'type': type,
      'audioUrl': audioUrl,
      'coverImageUrl': coverImageUrl,
      'postedBy': postedBy.toMap(),
      'uploadedAt': uploadedAt.toIso8601String(),
      'playCount': playCount,
      'tags': tags,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      type: map['type'],
      audioUrl: map['audioUrl'],
      coverImageUrl: map['coverImageUrl'],
      postedBy: PostedBy.fromMap(map['postedBy']),
      uploadedAt: DateTime.parse(map['uploadedAt']),
      playCount: map['playCount'],
      tags: List<String>.from(map['tags']),
    );
  }
}
