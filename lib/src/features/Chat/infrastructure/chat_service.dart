import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/Chat/domain/models/chat_room_model.dart';
import 'package:flutter_social_media/src/features/Chat/domain/models/message_model.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom(String userBId) async {
    var curentUser = await AuthRepository().getCurrentUserData();
    String userAId = curentUser!.uuid;
    List<String> sortedIds = [userAId, userBId]..sort();
    final chatId = '${sortedIds[0]}_${sortedIds[1]}';
    final chatRef = _firestore.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();
    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': sortedIds,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

  /// Sends a message in a given chat room
  Future<void> sendMessage({required String chatId, required MessageModel message}) async {
    final messageRef = _firestore.collection('chats').doc(chatId).collection('messages').doc(message.id);

    await messageRef.set(message.toMap());

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.content ?? message.type, // ?? message.mediaUrl,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    var deviceIds = await _getUserTokens(
      chatId,
      excludeUserId:
          "fENo4O9PRNqN1MswIlZW2b:APA91bGuehw_P3ENH99DXOOUYsQOVHJG4UNgJops4cAHsfhtmyTZEliwidY39x9sEWJBwZj7v8H38zzXpSUFQNv7ezSM_eDUeffnDXsyPr5yISNNc9-brs0",
    );
    await sendFCMToChat(chatId: chatId, message: message, userTokens: deviceIds);
  }

  /// Fetch messages in real-time
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromMap(doc.id, doc.data())).toList());
  }

  /// Updates the 'seenBy' field for a list of messages.
  ///
  /// This method finds all messages in the list that were not sent by the
  /// current user and that they have not yet seen, and updates them in a
  /// single atomic batch operation.
  Future<void> markMessagesAsSeen(String chatId, List<MessageModel> messages) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Use a WriteBatch to update multiple documents at once.
    final batch = FirebaseFirestore.instance.batch();
    int messagesToUpdateCount = 0;

    for (final message in messages) {
      // Check if the message was sent by someone else AND I haven't seen it yet.
      final bool wasSentByOther = message.senderId != currentUser.uid;
      final bool haveISeenIt = message.seenBy.contains(currentUser.uid);

      if (wasSentByOther && !haveISeenIt) {
        final messageRef = FirebaseHelper.chats.doc(chatId).collection('messages').doc(message.id);

        // Use FieldValue.arrayUnion to safely add the user's ID to the list.
        // This prevents duplicates and is an atomic operation.
        batch.update(messageRef, {
          'seenBy': FieldValue.arrayUnion([currentUser.uid]),
        });
        messagesToUpdateCount++;
      }
    }

    // Only commit the batch if there are actual updates to be made.
    if (messagesToUpdateCount > 0) {
      try {
        await batch.commit();
        log('Marked $messagesToUpdateCount messages as seen.');
      } catch (e) {
        log('Error marking messages as seen: $e');
      }
    }
  }

  Future<void> addReaction(String chatId, String messageId, String userId, String reaction) async {
    final messageRef = _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);

    await messageRef.update({'reactions.$userId': reaction});
  }

  Future<void> sendFCMToChat({
    required String chatId,
    required MessageModel message,
    required List<String> userTokens,
  }) async {
    final uri = Uri.parse(''); // TODO: Add FCM URL

    for (final token in userTokens) {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'type': 'chat',
          'chatId': chatId,
          'senderId': message.senderId,
          'message': message.content ?? message.mediaUrl ?? '',
        }),
      );

      if (response.statusCode != 200) {
        print('❌ Failed to send chat notification: ${response.statusCode} ${response.body}');
      } else {
        print('✅ Chat notification sent to $token');
      }
    }
  }

  /// Placeholder for fetching FCM tokens of chat participants
  Future<List<String>> _getUserTokens(String chatId, {required String excludeUserId}) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    List<String> participants = List<String>.from(chatDoc.data()?['participants'] ?? []);
    participants.remove(excludeUserId);

    List<String> tokens = [];
    for (String userId in participants) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final token = userDoc.data()?['deviceId'];
      if (token != null) tokens.add(token);
    }
    return tokens;
  }

  Future<List<ChatRoomModel>> getUserChatRooms() async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) {
        throw Exception('User not authenticated.');
      }

      final currentUserId = currentUser.uuid;

      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastUpdated', descending: true)
          .get();

      final List<ChatRoomModel> chatRooms = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final chatRoom = ChatRoomModel.fromMap(doc.id, data);

        final otherUserId = chatRoom.participants.firstWhere((id) => id != currentUserId, orElse: () => '');

        if (otherUserId.isNotEmpty) {
          final userDoc = await _firestore.collection('users').doc(otherUserId).get();
          final userData = userDoc.data();
          chatRoom.userId = userData?['uuid'];
          chatRoom.otherUserName = userData?['name'] ?? 'Unknown';
          chatRoom.otherUserImage = userData?['imageUrl'] ?? '';
        }

        chatRooms.add(chatRoom);
      }

      return chatRooms;
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition' && e.message?.contains('index') == true) {
        log('⚠️ Firestore index required: ${e.message}');
      } else {
        log('🔥 Firebase error: ${e.code} — ${e.message}');
      }
      return [];
    } catch (e, stackTrace) {
      log('❌ Unexpected error: $e');
      log('$stackTrace');
      return [];
    }
  }
}
