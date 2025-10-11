import 'dart:convert';
import 'package:flutter/foundation.dart';

enum NotificationType {
  like,
  comment,
  follow,
  mention,
  message,
  knotRequest,
  postPublished,
  bindPost,
  bindPostRequest,
  chatScreenshotTaken,
}

extension NotificationTypeExtension on NotificationType {
  String get name => toString().split('.').last;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere((e) => e.name == value, orElse: () => NotificationType.like);
  }
}

@immutable
class NotificationPayload {
  final String title;
  final String body;
  final String? image;
  final String? postId;
  final String? bindedPostId;
  final String? chatId;
  final String? commentId;
  final String? userId;

  const NotificationPayload({
    required this.title,
    required this.body,
    this.image,
    this.postId,
    this.bindedPostId,
    this.chatId,
    this.commentId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'postId': postId,
      'bindedPostId': bindedPostId,
      'chatId': chatId,
      'commentId': commentId,
      'userId': userId,
    };
  }

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      title: map['title'] as String? ?? 'No Title',
      body: map['body'] as String? ?? '',
      image: map['image'] as String? ?? '',
      postId: map['postId'] as String?,
      bindedPostId: map['bindedPostId'] as String?,
      chatId: map['chatId'] as String?,
      commentId: map['commentId'] as String?,
      userId: map['userId'] as String?,
    );
  }
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String senderUid;
  final DateTime createdAt;
  final bool read, isMuted;
  final NotificationPayload payload;

  const AppNotification({
    required this.id,
    required this.type,
    required this.senderUid,
    required this.createdAt,
    required this.payload,
    this.read = false,
    this.isMuted = false,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? senderUid,
    DateTime? createdAt,
    bool? read,
    bool? isMuted,
    NotificationPayload? payload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      senderUid: senderUid ?? this.senderUid,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      isMuted: isMuted ?? this.isMuted,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'senderUid': senderUid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'read': read,
      'isMuted': isMuted,
      'payload': payload.toMap(),
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      type: NotificationTypeExtension.fromString(map['type'] as String),
      senderUid: map['senderUid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      read: map['read'] as bool? ?? false,
      isMuted: map['isMuted'] as bool? ?? false,
      payload: NotificationPayload.fromMap(Map<String, dynamic>.from(map['payload'] ?? {})),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) => AppNotification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppNotification(id: $id, type: $type, senderUid: $senderUid, createdAt: $createdAt, read: $read, isMuted: $isMuted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppNotification &&
        other.id == id &&
        other.type == type &&
        other.senderUid == senderUid &&
        other.createdAt == createdAt &&
        other.read == read &&
        other.isMuted == isMuted &&
        other.payload == payload;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        senderUid.hashCode ^
        createdAt.hashCode ^
        read.hashCode ^
        isMuted.hashCode ^
        payload.hashCode;
  }
}
