import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';

class NotificationServices {
  Future<bool> sendNotification({
    required String receiverUid,
    required NotificationType type,
    required NotificationPayload payload,
  }) async {
    try {
      final String? currentUserId = await HiveHelper.getCurrentUserId();
      if (currentUserId == null) {
        throw Exception("Cannot send notification: No user is signed in.");
      }

      if (currentUserId == receiverUid) return true;

      final docId = const Uuid().v4();
      final notification = AppNotification(
        id: docId,
        senderUid: currentUserId,
        type: type,
        createdAt: DateTime.now(),
        payload: payload,
      );

      await FirebaseHelper.users.doc(receiverUid).collection('notifications').doc(docId).set(notification.toMap());

      log("Notification Sent to $receiverUid: type=${type.name}, payload=${payload.toMap()}");
      return true;
    } catch (e, st) {
      debugPrint('sendNotification error: $e\n$st');
      return false;
    }
  }
}
