import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_social_media/src/core/helpers/app_config.dart';
import 'package:flutter_social_media/src/core/presentation/app.dart';
import 'package:flutter_social_media/src/core/presentation/bootstrap.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/hive_post.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  AppConfig.initialize(
    environment: Environment.dev,
    baseUrl: 'https://dev.api.example.com',
    appName: 'Flutter Social Media (Dev)',
  );
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HivePostAdapter());
  await bootStrap();

  setupCallkitListeners();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleIncomingCallRemoteMessage(message);
  });

  await localNotificationService.initialize();

  // Deep Link
  final appLinks = AppLinks();

  // Subscribe to all events (initial link and further)
  final sub = appLinks.uriLinkStream.listen((uri) {
    log("URI: ${uri.toString()}");
  });

  runApp(const App());
}
