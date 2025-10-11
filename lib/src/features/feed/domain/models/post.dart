import 'package:equatable/equatable.dart';
import 'package:flutter_social_media/src/features/feed/application/like_cubit/like_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';

enum PostPrivacy {
  PUBLIC,
  FRIENDS,
  ONLYME;

  /// Defaults to [PostPrivacy.GLOBAL] if the input is null or unknown.
  static PostPrivacy fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'friends':
        return PostPrivacy.FRIENDS;
      case 'onlyme':
      case 'only_me':
        return PostPrivacy.ONLYME;
      case 'public':
      default:
        return PostPrivacy.PUBLIC;
    }
  }
}

class Post extends Equatable {
  final bool? isVideo;
  final bool? isAudio;
  final PostPrivacy privacy;
  final String id;
  final PostedBy postedBy;
  final String postedAt;
  final String? caption;
  final List<String>? attachment;
  final int upvotes;
  final int downvotes;
  final int commentCount;
  final List<String> tags;
  final String? refId;
  final int score;

  /// current user's vote (up / down / none)
  VoteType userVote;

  final int? timePeriodInHour;
  final String? bindedPostId;
  final int bindedPostCount;

  /// UI-only
  Post? bindedPost;

  Post({
    this.isVideo,
    this.isAudio,
    this.refId,
    this.privacy = PostPrivacy.PUBLIC,
    required this.id,
    required this.postedBy,
    required this.postedAt,
    this.caption,
    this.attachment,
    this.upvotes = 0,
    this.downvotes = 0,
    this.commentCount = 0,
    required this.tags,
    this.userVote = VoteType.none,
    this.timePeriodInHour,
    this.bindedPostId,
    this.bindedPostCount = 0,
    this.bindedPost,
    this.score = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      isVideo: json['isVideo'],
      isAudio: json['isAudio'],
      refId: json['refId'],
      privacy: PostPrivacy.fromString(json['privacy']),
      id: json['id'],
      postedBy: PostedBy.fromMap(json['postedBy']),
      postedAt: json['postedAt'],
      caption: json['caption'],
      attachment: (json['attachment'] as List?)?.map((e) => e as String).toList(),
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      timePeriodInHour: json['timePeriodInHour'] as int?,
      bindedPostId: json['bindedPostId'],
      bindedPostCount: json['bindedPostCount'] ?? 0,
      userVote: VoteType.none, // will be set later in repository
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVideo': isVideo,
      'isAudio': isAudio,
      'refId': refId,
      'privacy': privacy.name,
      'id': id,
      'postedBy': postedBy.toMap(),
      'postedAt': postedAt,
      'caption': caption,
      'attachment': attachment,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'tags': tags,
      if (timePeriodInHour != null) 'timePeriodInHour': timePeriodInHour,
      'bindedPostId': bindedPostId,
      'bindedPostCount': bindedPostCount,
      'score': score,
    };
  }

  Post copyWith({
    bool? isVideo,
    bool? isAudio,
    PostPrivacy? privacy,
    String? id,
    PostedBy? postedBy,
    String? postedAt,
    String? caption,
    List<String>? attachment,
    int? upvotes,
    int? downvotes,
    int? commentCount,
    List<String>? tags,
    String? refId,
    VoteType? userVote,
    int? timePeriodInHour,
    String? bindedPostId,
    int? bindedPostCount,
    Post? bindedPost,
    int score = 0,
  }) {
    return Post(
      isVideo: isVideo ?? this.isVideo,
      isAudio: isAudio ?? this.isAudio,
      privacy: privacy ?? this.privacy,
      id: id ?? this.id,
      postedBy: postedBy ?? this.postedBy,
      postedAt: postedAt ?? this.postedAt,
      caption: caption ?? this.caption,
      attachment: attachment ?? this.attachment,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      tags: tags ?? this.tags,
      refId: refId ?? this.refId,
      userVote: userVote ?? this.userVote,
      timePeriodInHour: timePeriodInHour ?? this.timePeriodInHour,
      bindedPostId: bindedPostId ?? this.bindedPostId,
      bindedPostCount: bindedPostCount ?? this.bindedPostCount,
      bindedPost: bindedPost ?? this.bindedPost,
      score: score,
    );
  }

  @override
  List<Object?> get props => [
    isVideo,
    isAudio,
    privacy,
    id,
    postedBy,
    postedAt,
    caption,
    attachment,
    upvotes,
    downvotes,
    commentCount,
    tags,
    refId,
    userVote,
    timePeriodInHour,
    bindedPostId,
    bindedPostCount,
    bindedPost,
    score,
  ];
}
