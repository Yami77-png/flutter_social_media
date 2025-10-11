import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_social_media/injection.dart';
import 'package:flutter_social_media/firebase_options.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/router/router_config.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Chat/application/call_cubit.dart';
import 'package:flutter_social_media/src/sandbox/webroomrtc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await handleIncomingCallRemoteMessage(message);
}

Future<void> bootStrap() async {
  // log("Main running");
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  //app rotation, only portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //statusbar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));

  await Hive.initFlutter();
  final isFirstTime = await HiveHelper.isFirstTimeUser();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: Enable Crashlytics in production
  // await configureCrashlytics();

  // TODO: remove firebase emulators in production
  // Firebase Emulators Setup
  // try {
  //   // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //   // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   // await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  //   FirebaseFirestore.instance.useFirestoreEmulator('192.168.0.171', 8080);
  //   await FirebaseAuth.instance.useAuthEmulator('192.168.0.171', 9099);
  //   await FirebaseStorage.instance.useStorageEmulator('192.168.0.171', 9199);
  // } catch (e) {
  //   log(e.toString());
  // }

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   // webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
  // );
  // await FlutterCallkitIncoming.requestFullIntentPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupCallkitListeners();
}

void navigateToCallScreen({
  required String callerName,
  required String callerImage,
  required String callId,
  required String callerId,
  required bool isCaller,
  required bool isVideoCall,
}) async {
  // var currentUser = await AuthRepository().getCurrentUserData();
  final currentUserId = await HiveHelper.getCurrentUserId();

  NavigationService.instance.navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: //
      (_) => CallScreen(
        name: callerName,
        imageUrl: callerImage,
        callId: callId,
        localId: currentUserId ?? '',
        remoteId: callerId,
        isCaller: isCaller,
        isVideoCall: isVideoCall,
      ),
    ),
  );
}

void setupCallkitListeners() {
  FlutterCallkitIncoming.onEvent.listen((event) async {
    print('🔔 Call kit Event: ${event?.event}');
    final callId = event?.body['id'];
    final extra = event?.body['extra'];

    switch (event!.event) {
      case Event.actionCallAccept:
        final callerId = extra['callerId'];
        final callerName = extra['callerName'] as String?;
        final callerImage = extra['callerImage'] as String?;
        final isVideoCall = extra['isVideoCall'] == true;
        navigateToCallScreen(
          callId: callId,
          callerId: callerId,
          isCaller: false,
          isVideoCall: isVideoCall,
          callerName: callerName ?? '',
          callerImage: callerImage ?? '',
        );
        await WebRTCRoomService().endCall(callId, CallStatus.answered.name);
        _handleCallStatusUI(CallStatus.answered.name);
        log('Call answered: $callId');
        break;

      case Event.actionCallDecline:
        await WebRTCRoomService().endCall(callId, CallStatus.declined.name);
        _handleCallStatusUI(CallStatus.declined.name);
        log('Call declined: $callId');
        break;

      case Event.actionCallEnded:
        await WebRTCRoomService().endCall(callId, CallStatus.ended.name);
        _handleCallStatusUI(CallStatus.ended.name);
        log('Call ended: $callId');
        break;

      default:
        log("Unhandled CallKit event: ${event.event}");
    }
  });
}

void _handleCallStatusUI(String callStatus) {
  if (callStatus == CallStatus.declined.name)
    CallCubit().callDeclined();
  else if (callStatus == CallStatus.ended.name)
    CallCubit().callEnded();
  else if (callStatus == CallStatus.missed.name)
    CallCubit().callMissed();
  else if (callStatus == CallStatus.idle.name)
    CallCubit().reset();
}

Future<void> handleIncomingCallRemoteMessage(RemoteMessage message) async {
  if (message.data['type'] == 'call') {
    final callId = message.data['callId'];
    final callerId = message.data['callerId'];
    final callerName = message.data['callerName'];
    final callerImage = message.data['callerImage'];
    final isCaller = message.data['isCaller'];
    final isVideoCall = message.data['isVideoCall'] == 'true';

    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: callId,
        nameCaller: callerName,
        appName: 'Flutter Social Media',
        avatar: callerImage ?? 'assets/app_logo/appLogo.png',
        handle: 'Caller',
        type: 0,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',

        extra: {'callerId': callerId, 'isVideoCall': isVideoCall, 'isCaller': isCaller},
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#2D2D2D',
          backgroundUrl: '',
          actionColor: '#4CAF50',
        ),
        ios: const IOSParams(iconName: 'CallKitIcon', handleType: 'generic'),
      ),
    );
  }
}

Future<void> configureCrashlytics() async {
  final crashlytics = FirebaseCrashlytics.instance;

  final bool fatalInThisBuild = kReleaseMode; // true for main_prod.dart

  await _addGlobalKeys(crashlytics);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);

    if (fatalInThisBuild) {
      crashlytics.recordFlutterFatalError(details);
    } else {
      crashlytics.recordFlutterError(details);
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    if (fatalInThisBuild) {
      crashlytics.recordError(error, stack, fatal: true);
    } else {
      crashlytics.recordError(error, stack, fatal: false);
    }
    return true;
  };
}

Future<void> _addGlobalKeys(FirebaseCrashlytics crashlytics) async {
  final info = await PackageInfo.fromPlatform();
  await crashlytics.setCustomKey('appName', info.appName);
  await crashlytics.setCustomKey('packageName', info.packageName);
  await crashlytics.setCustomKey('version', info.version);
  await crashlytics.setCustomKey('buildNumber', info.buildNumber);

  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final android = await deviceInfo.androidInfo;
    await crashlytics.setCustomKey('androidModel', android.model);
    await crashlytics.setCustomKey('androidVersion', android.version.release);
  } else if (Platform.isIOS) {
    final ios = await deviceInfo.iosInfo;
    await crashlytics.setCustomKey('iosModel', ios.utsname.machine);
    await crashlytics.setCustomKey('iosVersion', ios.systemVersion);
  }

  final user = await AuthRepository().getCurrentUserData();
  if (user != null) {
    await crashlytics.setUserIdentifier(user.uuid);
    await crashlytics.setCustomKey('userEmail', user.email ?? '');
    await crashlytics.setCustomKey('userName', user.name ?? '');
  }
}
