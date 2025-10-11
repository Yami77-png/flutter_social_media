// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/call_event.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
// import 'package:flutter_social_media/src/sandbox/webroomrtc.dart';

// class WebRTCTestPage extends StatefulWidget {
//   final String callId;
//   final bool isCaller;
//   final bool isVideoCall;
//   final String localId;
//   final String remoteId;
//   const WebRTCTestPage({
//     super.key,
//     required this.callId,
//     required this.isCaller,
//     required this.isVideoCall,
//     required this.localId,
//     required this.remoteId,
//   });

// static const String route = 'web_rtc_test';
//   @override
//   State<WebRTCTestPage> createState() => _WebRTCTestPageState();
// }

// class _WebRTCTestPageState extends State<WebRTCTestPage> {
//   final WebRTCRoomService _service = WebRTCRoomService();
//   final TextEditingController _roomIdController = TextEditingController();

//   String? _activeCallId;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _setupCallKitEvents();
//     _createRoom();
//   }

//   @override
//   void dispose() {
//     if (_activeCallId != null) {
//       _service.dispose(_activeCallId!);
//     }
//     _roomIdController.dispose();
//     super.dispose();
//   }

//   Future<void> _createRoom() async {
//     log("Create room Pressed");
//     final roomId = await _service.createRoom();
//     setState(() {
//       _activeCallId = roomId;
//     });
//     print('==========roomId: $roomId');
//   }

//   Future<void> _joinRoom() async {
//     log(" room Pressed");
//     final roomId = _roomIdController.text.trim();
//     if (roomId.isEmpty) return;
//     await _service.joinRoom(roomId);
//     setState(() {
//       _activeCallId = roomId;
//     });
//   }

//   void _setupCallKitEvents() {
//     FlutterCallkitIncoming.onEvent.listen((event) {
//       final eventName = event?.event;

//       if (eventName == Event.actionCallAccept) {
//         // final body = event?.body;

//         // final callId = body['id'] as String;
//         // final isCaller = (body['extra']?['isCaller'] ?? 'true').toLowerCase() == 'true';
//         // final isVideoCall = (body['extra']?['isVideoCall'] ?? false) == true;
//         // final localId = body['extra']?['callerId'] as String? ?? '';
//         // final remoteId = body['extra']?['receiverId'] as String? ?? '';

//         final callId = widget.callId;
//         final isCaller = widget.isCaller;
//         final isVideoCall = widget.isVideoCall;
//         final localId = widget.localId;
//         final remoteId = widget.remoteId;

//         final callRecord = (
//           callId: callId,
//           isCaller: isCaller,
//           isVideoCall: isVideoCall,
//           localId: localId,
//           remoteId: remoteId,
//         );
//         inspect(callRecord);

//         WidgetsBinding.instance.addPostFrameCallback((_) {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localRenderer = _activeCallId != null ? _service.getLocalRenderer(_activeCallId!) : null;
//     final remoteRenderer = _activeCallId != null ? _service.getRemoteRenderer(_activeCallId!) : null;

//     return Scaffold(
//       appBar: AppBar(title: const Text('WebRTC Test')),
//       body: Column(
//         children: [
//           if (_activeCallId == null) ...[
//             Center(child: CircularProgressIndicator()),
//             // Padding(
//             //   padding: const EdgeInsets.all(12),
//             //   child: TextField(
//             //     controller: _roomIdController,
//             //     decoration: const InputDecoration(labelText: 'Enter Room ID to Join'),
//             //   ),
//             // ),
//             // ElevatedButton(onPressed: _createRoom, child: const Text('Create Room')),
//             // ElevatedButton(onPressed: _joinRoom, child: const Text('Join Room')),
//           ] else ...[
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child:
//                           localRenderer != null
//                               ? RTCVideoView(localRenderer, mirror: true)
//                               : const Center(child: Text("No Local Video")),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.black54,
//                       child:
//                           remoteRenderer != null
//                               ? RTCVideoView(remoteRenderer)
//                               : const Center(child: Text("Waiting for Remote")),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text("Room ID: $_activeCallId"),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_activeCallId != null) {
//                   await _service.dispose(_activeCallId!);
//                   setState(() {
//                     _activeCallId = null;
//                   });
//                 }
//                 context.pop();
//               },
//               child: const Text('Hang Up'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
