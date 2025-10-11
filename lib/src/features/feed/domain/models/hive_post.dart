import 'package:hive/hive.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';

@HiveType(typeId: 2)
class HivePost extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? privacy;

  @HiveField(2)
  String postedAt;

  @HiveField(3)
  String? caption;

  @HiveField(4)
  List<String> attachment;

  @HiveField(5)
  int upvotes;

  @HiveField(6)
  int downvotes;

  @HiveField(7)
  int commentCount;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  String postedById;

  @HiveField(10)
  String postedByName;

  @HiveField(11)
  String postedByImageUrl;

  @HiveField(12)
  String? bindedPostId;

  @HiveField(13)
  int bindedPostCount;

  @HiveField(14)
  String? bindedPostCaption;

  @HiveField(15)
  String? bindedPostImageUrl;

  @HiveField(16)
  int score;

  HivePost({
    required this.id,
    this.privacy,
    required this.postedAt,
    this.caption,
    List<String>? attachment,
    this.upvotes = 0,
    this.downvotes = 0,
    this.commentCount = 0,
    List<String>? tags,
    required this.postedById,
    required this.postedByName,
    required this.postedByImageUrl,
    this.bindedPostId,
    this.bindedPostCount = 0,
    this.bindedPostCaption,
    this.bindedPostImageUrl,
    this.score = 0,
  }) : attachment = attachment ?? [],
       tags = tags ?? [];

  factory HivePost.fromPost(Post post) => HivePost(
    id: post.id,
    privacy: post.privacy.name,
    postedAt: post.postedAt,
    caption: post.caption,
    attachment: post.attachment ?? [],
    upvotes: post.upvotes,
    downvotes: post.downvotes,
    commentCount: post.commentCount,
    tags: post.tags,
    postedById: post.postedBy.id,
    postedByName: post.postedBy.name,
    postedByImageUrl: post.postedBy.imageUrl,
    bindedPostId: post.bindedPostId,
    bindedPostCount: post.bindedPostCount,
    bindedPostCaption: post.bindedPost?.caption,
    bindedPostImageUrl: post.bindedPost?.attachment?.isNotEmpty == true ? post.bindedPost!.attachment!.first : null,
    score: post.score,
  );

  Post toPost() => Post(
    id: id,
    privacy: PostPrivacy.fromString(privacy),
    postedAt: postedAt,
    caption: caption,
    attachment: attachment,
    upvotes: upvotes,
    downvotes: downvotes,
    commentCount: commentCount,
    tags: tags,
    postedBy: PostedBy(id: postedById, name: postedByName, imageUrl: postedByImageUrl),
    bindedPostId: bindedPostId,
    bindedPostCount: bindedPostCount,
    bindedPost: bindedPostId != null
        ? Post(
            id: bindedPostId!,
            caption: bindedPostCaption,
            attachment: bindedPostImageUrl != null ? [bindedPostImageUrl!] : null,
            postedAt: "",
            tags: [],
            postedBy: PostedBy(id: "", name: "", imageUrl: ""),
          )
        : null,
    score: score,
  );
}

class HivePostAdapter extends TypeAdapter<HivePost> {
  @override
  final int typeId = 2;

  @override
  HivePost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};

    return HivePost(
      id: fields[0] as String,
      privacy: fields[1] as String?,
      postedAt: fields[2] as String,
      caption: fields[3] as String?,
      attachment: (fields[4] as List?)?.cast<String>() ?? [],
      upvotes: fields[5] as int,
      downvotes: fields[6] as int,
      commentCount: fields[7] as int? ?? 0,
      tags: (fields[8] as List?)?.cast<String>() ?? [],
      postedById: fields[9] as String,
      postedByName: fields[10] as String,
      postedByImageUrl: fields[11] as String,
      bindedPostId: fields[12] as String?,
      bindedPostCount: fields[13] as int? ?? 0,
      bindedPostCaption: fields[14] as String?,
      bindedPostImageUrl: fields[15] as String?,
      score: fields[16] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HivePost obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.privacy)
      ..writeByte(2)
      ..write(obj.postedAt)
      ..writeByte(3)
      ..write(obj.caption)
      ..writeByte(4)
      ..write(obj.attachment)
      ..writeByte(5)
      ..write(obj.upvotes)
      ..writeByte(6)
      ..write(obj.downvotes)
      ..writeByte(7)
      ..write(obj.commentCount)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.postedById)
      ..writeByte(10)
      ..write(obj.postedByName)
      ..writeByte(11)
      ..write(obj.postedByImageUrl)
      ..writeByte(12)
      ..write(obj.bindedPostId)
      ..writeByte(13)
      ..write(obj.bindedPostCount)
      ..writeByte(14)
      ..write(obj.bindedPostCaption)
      ..writeByte(15)
      ..write(obj.bindedPostImageUrl)
      ..writeByte(16)
      ..write(obj.score);
  }
}
