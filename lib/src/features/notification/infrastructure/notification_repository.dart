import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';

class NotificationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // real-time stream of notifications.
  Stream<List<AppNotification>> getNotificationsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseHelper.users
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => AppNotification.fromMap(doc.data())).toList();
        });
  }

  Future<void> deleteNotification(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Cannot delete notification: No user is signed in.");
    }
    try {
      await FirebaseHelper.users.doc(user.uid).collection('notifications').doc(notificationId).delete();
      log('Deleted notification: $notificationId');
    } catch (e) {
      log('Error deleting notification: $e');
      rethrow;
    }
  }

  /// Mark all notification as "read"
  Future<void> markAllAsRead() async {
    final currentUserId = await HiveHelper.getCurrentUserId();
    if (currentUserId == null) return;

    final notificationsRef = FirebaseHelper.users.doc(currentUserId).collection('notifications');

    // Get all unread notifications
    final unreadSnapshot = await notificationsRef.where('read', isEqualTo: false).get();

    if (unreadSnapshot.docs.isEmpty) {
      log('No unread notifications to mark.');
      return;
    }

    // Create a batched write to update all of them in one go
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
    log('Marked ${unreadSnapshot.docs.length} notifications as read.');
  }

  Future<void> markAsRead(String notificationId) async {
    final currentUserId = await HiveHelper.getCurrentUserId();
    if (currentUserId == null) return;

    try {
      await FirebaseHelper.users.doc(currentUserId).collection('notifications').doc(notificationId).update({
        'read': true,
      });
      log('Marked single notification as read: $notificationId');
    } catch (e) {
      log('Error marking single notification as read: $e');
      rethrow;
    }
  }

  Future<void> updateNotificationBody(String notificationId, String body) async {
    final currentUserId = await HiveHelper.getCurrentUserId();
    if (currentUserId == null) return;

    try {
      await FirebaseHelper.users.doc(currentUserId).collection('notifications').doc(notificationId).update({
        'body': body,
      });
      log('Marked single notification as read: $notificationId');
    } catch (e) {
      log('Error marking single notification as read: $e');
      rethrow;
    }
  }
}
