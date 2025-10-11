import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialization settings for Android
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/launcher_icon');

    // Initialization settings for iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    log('LocalNotificationService Initialized');
  }

  Future<void> showNotification({required AppNotification notif}) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '${notif.type}', //'your_channel_id',
      '${notif.type}', //'Your Channel Name',
      channelDescription: '${notif.payload.title}',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Notification ID
      notif.payload.title,
      notif.payload.body,
      notificationDetails,
    );
  }
}

//https://github.com/MaikuB/flutter_local_notifications/issues/2286
//https://stackoverflow.com/questions/79158012/dependency-flutter-local-notifications-requires-core-library-desugaring-to-be
