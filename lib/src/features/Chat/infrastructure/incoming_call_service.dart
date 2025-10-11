// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class IncomingCallService {
//   static final FlutterCallkitIncoming _callKit = FlutterCallkitIncoming();

//   /// Initialize this in your app's main function or initState
//   static Future<void> initialize() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final data = message.data;
//       if (data['type'] == 'call') {
//         _showIncomingCallUI(
//           callId: data['callId']!,
//           callerName: data['callerName']!,
//           isVideoCall: data['isVideoCall'] == 'true',
//         );
//       }
//     });

//     _callKit.onEvent.listen((event) async {
//       switch (event?.event) {
//         case Event.ACTION_CALL_ACCEPT:
//           _handleCallAccept(event?.body);
//           break;
//         case Event.ACTION_CALL_DECLINE:
//         case Event.ACTION_CALL_ENDED:
//           _handleCallEnd(event?.body);
//           break;
//         default:
//           break;
//       }
//     });
//   }

//   static Future<void> _showIncomingCallUI({
//     required String callId,
//     required String callerName,
//     required bool isVideoCall,
//   }) async {
//     final params = <String, dynamic>{
//       'id': callId,
//       'nameCaller': callerName,
//       'appName': 'Flutter Social Media',
//       'avatar': '', // optional: URL to caller avatar
//       'handle': 'Caller',
//       'type': isVideoCall ? 1 : 0,
//       'duration': 30000,
//       'textAccept': 'Accept',
//       'textDecline': 'Reject',
//       'textMissedCall': 'Missed call from $callerName',
//       'textCallback': 'Call back',
//       'extra': {'callType': isVideoCall ? 'video' : 'audio'},
//     };

//     await _callKit.showCallkitIncoming(params);
//   }

//   static void _handleCallAccept(Map<String, dynamic>? body) {
//     final callId = body?['id'];
//     print('Call accepted: $callId');
//     // TODO: Start the WebRTC session here
//   }

//   static void _handleCallEnd(Map<String, dynamic>? body) {
//     final callId = body?['id'];
//     print('Call ended/rejected: $callId');
//     // TODO: Clean up session, notify Firestore, etc.
//   }

//   /// End call manually (if needed)
//   static Future<void> endCall(String callId) async {
//     await _callKit.endCall(callId);
//   }
// }
