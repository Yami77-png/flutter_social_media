import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_social_media/src/core/helpers/app_config.dart';
import 'package:flutter_social_media/src/core/presentation/app.dart';
import 'package:flutter_social_media/src/core/presentation/bootstrap.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/hive_post.dart';

void main() async {
  AppConfig.initialize(
    environment: Environment.prod,
    baseUrl: 'https://dev.api.example.com',
    appName: 'Flutter Social Media (Dev)',
  );

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  log("===[Prod]===");

  await Hive.initFlutter();
  Hive.registerAdapter(HivePostAdapter());
  await bootStrap();

  setupCallkitListeners();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleIncomingCallRemoteMessage(message);
  });

  runApp(const App());
}
