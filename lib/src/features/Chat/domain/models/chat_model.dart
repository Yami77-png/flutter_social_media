import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final bool isGroup;
  final String? groupName;
  final String? groupImage;
  final List<String> members;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final Map<String, bool> typing;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.isGroup,
    this.groupName,
    this.groupImage,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.typing,
    required this.createdAt,
  });

  factory ChatModel.fromMap(String id, Map<String, dynamic> data) {
    return ChatModel(
      id: id,
      isGroup: data['isGroup'],
      groupName: data['groupName'],
      groupImage: data['groupImage'],
      members: List<String>.from(data['members']),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTimestamp: (data['lastMessageTimestamp'] as Timestamp).toDate(),
      typing: Map<String, bool>.from(data['typing'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'isGroup': isGroup,
    'groupName': groupName,
    'groupImage': groupImage,
    'members': members,
    'lastMessage': lastMessage,
    'lastMessageTimestamp': Timestamp.fromDate(lastMessageTimestamp),
    'typing': typing,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
