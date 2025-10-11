import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final Timestamp? createdAt;
  final Timestamp? lastUpdated;
  String? otherUserName;
  String? otherUserImage;
  String? userId;

  ChatRoomModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.createdAt,
    this.lastUpdated,
    this.otherUserImage,
    this.otherUserName,
    this.userId,
  });

  factory ChatRoomModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoomModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'],
      createdAt: map['createdAt'],
      lastUpdated: map['lastUpdated'],
      otherUserImage: map['otherUserImage'],
      otherUserName: map['otherUserName'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
      'otherUserName': otherUserName,
      'otherUserImage': otherUserImage,
      'userId': userId,
    };
  }
}
