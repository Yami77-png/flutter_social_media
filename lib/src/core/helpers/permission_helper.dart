import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  Future<void> requestAllPermissions() async {
    await requestNotificationPermission();
    await requestMicrophonePermission();
  }

  Future<PermissionStatus> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Also check with permission_handler in case additional prompting is needed
    final notificationStatus = await Permission.notification.status;

    if (notificationStatus.isDenied || notificationStatus.isRestricted) {
      final requestedStatus = await Permission.notification.request();
      log('Requested notification permission result: $requestedStatus');
      return requestedStatus;
    }

    return notificationStatus;
  }

  Future<PermissionStatus> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      log('Microphone permission granted.');
    } else if (status.isDenied) {
      log('Microphone permission denied.');
    } else if (status.isPermanentlyDenied) {
      log('Microphone permission permanently denied. Please enable it from settings.');
    }

    return status;
  }
}
