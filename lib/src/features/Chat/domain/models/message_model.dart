import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio, file }

class MessageModel {
  final String id;
  final String senderId;
  final String? content;
  final String? mediaUrl;
  final MessageType type;
  final DateTime timestamp;
  final List<String> seenBy;
  final Map<String, String> reactions;

  MessageModel({
    required this.id,
    required this.senderId,
    this.content,
    this.mediaUrl,
    required this.type,
    required this.timestamp,
    required this.seenBy,
    required this.reactions,
  });

  factory MessageModel.fromMap(String id, Map<String, dynamic> data) {
    return MessageModel(
      id: id,
      senderId: data['senderId'],
      content: data['content'],
      mediaUrl: data['mediaUrl'],
      type: MessageType.values.byName(data['type']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      seenBy: List<String>.from(data['seenBy'] ?? []),
      reactions: Map<String, String>.from(data['reactions'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'content': content,
    'mediaUrl': mediaUrl,
    'type': type.name,
    'timestamp': Timestamp.fromDate(timestamp),
    'seenBy': seenBy,
    'reactions': reactions,
  };
}
