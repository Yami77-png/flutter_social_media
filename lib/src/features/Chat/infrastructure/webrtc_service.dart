// import 'dart:convert';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
// import 'package:uuid/uuid.dart';

// class WebRTCService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Map<String, RTCPeerConnection> _peerConnections = {};
//   final Map<String, MediaStream> _localStreams = {};
//   final Map<String, MediaStream> _remoteStreams = {};
//   final Map<String, RTCVideoRenderer> _localRenderers = {};
//   final Map<String, RTCVideoRenderer> _remoteRenderers = {};

//   Future<MediaStream> createMediaStream({bool video = true}) async {
//     final mediaConstraints = {
//       'audio': true,
//       'video': video ? {'facingMode': 'user', 'width': 640, 'height': 480, 'frameRate': 30} : false,
//     };
//     return await navigator.mediaDevices.getUserMedia(mediaConstraints);
//   }

//   Future<void> startCall({required String callerId, required String receiverId, bool isVideoCall = true,  required String callId}) async {
//     final receiverFcmToken = await getDeviceToken(receiverId);
//     final localStream = await createMediaStream(video: isVideoCall);
//     _localStreams[callId] = localStream;

//     final localRenderer = RTCVideoRenderer();
//     await localRenderer.initialize();
//     localRenderer.srcObject = localStream;
//     _localRenderers[callId] = localRenderer;

//     final peerConnection = await _createPeerConnection(callId, callerId, receiverId, isOfferer: true);
//     _peerConnections[callId] = peerConnection;

//     for (var track in localStream.getTracks()) {
//       peerConnection.addTrack(track, localStream);
//     }

//     final offer = await peerConnection.createOffer();
//     await peerConnection.setLocalDescription(offer);

//     final offerData = SessionDescription(sdp: offer.sdp!, type: offer.type!);
//     final callDoc = CallDocument(
//       callId: callId,
//       callerId: callerId,
//       receiverId: receiverId,
//       sessionDescription: offerData,
//       isVideoCall: isVideoCall,
//     );

//     final user = await AuthRepository().getCurrentUserData();
//     await _firestore.collection('calls').doc(callId).set(callDoc.toMap());

//     await sendFCMToCall(
//       callId: callId,
//       callerId: callerId,
//       callerName: user!.name,
//       receiverFcmToken: receiverFcmToken!,
//       isVideoCall: isVideoCall,
//     );

//     _firestore.collection('calls').doc(callId).snapshots().listen((docSnapshot) async {
//       if (!docSnapshot.exists) return;
//       final data = docSnapshot.data();
//       if (data == null) return;

//       final sdpAnswer = data['sdpAnswer'];
//       final typeAnswer = data['typeAnswer'];
//       if (sdpAnswer != null && typeAnswer != null) {
//         final pc = _peerConnections[callId];
//         if (pc != null) {
//           final answerDesc = RTCSessionDescription(sdpAnswer, typeAnswer);
//           await pc.setRemoteDescription(answerDesc);
//         }
//       }
//     });
//   }

//   Future<void> answerCall(String callId, String receiverId) async {
//     final doc = await _firestore.collection('calls').doc(callId).get();
//     if (!doc.exists) return;

//     final data = CallDocument.fromMap(doc.data()!);
//     final localStream = await createMediaStream(video: data.isVideoCall);
//     _localStreams[callId] = localStream;

//     final localRenderer = RTCVideoRenderer();
//     await localRenderer.initialize();
//     localRenderer.srcObject = localStream;
//     _localRenderers[callId] = localRenderer;

//     final peerConnection = await _createPeerConnection(callId, data.callerId, receiverId, isOfferer: false);
//     _peerConnections[callId] = peerConnection;

//     for (var track in localStream.getTracks()) {
//       peerConnection.addTrack(track, localStream);
//     }

//     final remoteDesc = RTCSessionDescription(data.sessionDescription.sdp, data.sessionDescription.type);
//     await peerConnection.setRemoteDescription(remoteDesc);

//     final answer = await peerConnection.createAnswer();
//     await peerConnection.setLocalDescription(answer);

//     final answerData = SessionDescription(sdp: answer.sdp!, type: answer.type!);
//     await _firestore.collection('calls').doc(callId).update({
//       'sdpAnswer': answerData.sdp,
//       'typeAnswer': answerData.type,
//     });
//   }

//   Future<RTCPeerConnection> _createPeerConnection(
//     String callId,
//     String callerId,
//     String receiverId, {
//     bool isOfferer = false,
//   }) async {
//     final config = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {'urls': 'turn:openrelay.metered.ca:80', 'username': 'openrelayproject', 'credential': 'openrelayproject'}
//       ],
//     };

//     final pc = await createPeerConnection(config);

//     pc.onIceCandidate = (candidate) {
//       final candidateData = IceCandidateData(
//         candidate: candidate.candidate!,
//         sdpMid: candidate.sdpMid,
//         sdpMLineIndex: candidate.sdpMLineIndex,
//         from: isOfferer ? callerId : receiverId,
//       );
//       _firestore.collection('calls').doc(callId).collection('candidates').add(candidateData.toMap());
//     };

//     pc.onIceConnectionState = (state) {
//       print('📡 ICE connection state: $state');
//     };

//     pc.onTrack = (event) async {
//       if (event.streams.isNotEmpty) {
//         final remoteStream = event.streams.first;
//         _remoteStreams[callId] = remoteStream;

//         final remoteRenderer = RTCVideoRenderer();
//         await remoteRenderer.initialize();
//         remoteRenderer.srcObject = remoteStream;
//         _remoteRenderers[callId] = remoteRenderer;
//       }
//     };

//     _firestore.collection('calls').doc(callId).collection('candidates').snapshots().listen((snapshot) {
//       for (var change in snapshot.docChanges) {
//         if (change.type == DocumentChangeType.added) {
//           final data = IceCandidateData.fromMap(change.doc.data()!);
//           if (data.from != (isOfferer ? callerId : receiverId)) {
//             final candidate = RTCIceCandidate(data.candidate, data.sdpMid, data.sdpMLineIndex);
//             pc.addCandidate(candidate);
//           }
//         }
//       }
//     });

//     return pc;
//   }

//   Future<void> endCall(String callId) async {
//     await _peerConnections[callId]?.close();
//     _peerConnections.remove(callId);

//     await _localStreams[callId]?.dispose();
//     await _remoteStreams[callId]?.dispose();
//     _localStreams.remove(callId);
//     _remoteStreams.remove(callId);

//     await _localRenderers[callId]?.dispose();
//     await _remoteRenderers[callId]?.dispose();
//     _localRenderers.remove(callId);
//     _remoteRenderers.remove(callId);

//     await _firestore.collection('calls').doc(callId).delete();
//   }

//   MediaStream? getLocalStream(String callId) => _localStreams[callId];
//   MediaStream? getRemoteStream(String callId) => _remoteStreams[callId];
//   RTCVideoRenderer? getLocalRenderer(String callId) => _localRenderers[callId];
//   RTCVideoRenderer? getRemoteRenderer(String callId) => _remoteRenderers[callId];

//   Future<String?> getDeviceToken(String receiverId) async {
//     try {
//       final snapshot = await _firestore.collection('users').doc(receiverId).get();
//       if (snapshot.exists) {
//         final data = snapshot.data();
//         return data?['deviceId'];
//       }
//     } catch (e) {
//       print('Error getting device token: $e');
//     }
//     return null;
//   }

//   Future<void> sendFCMToCall({
//     required String callId,
//     required String callerId,
//     required String callerName,
//     required String receiverFcmToken,
//     required bool isVideoCall,
//   }) async {
//     final uri = Uri.parse(''); // TODO: Add FCM URL

//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'token': receiverFcmToken,
//         'type': 'call',
//         'callId': callId,
//         'callerId': callerId,
//         'callerName': callerName,
//         'isVideoCall': isVideoCall.toString(),
//         'isCaller': false,
//       }),
//     );

//     if (response.statusCode != 200) {
//       print('❌ FCM send failed: ${response.statusCode} ${response.body}');
//     } else {
//       print('✅ FCM sent to $receiverFcmToken');
//     }
//   }
// }

// // --- Support Models ---

// class SessionDescription {
//   final String sdp;
//   final String type;

//   SessionDescription({required this.sdp, required this.type});

//   Map<String, dynamic> toMap() => {'sdp': sdp, 'type': type};

//   factory SessionDescription.fromMap(Map<String, dynamic> map) =>
//       SessionDescription(sdp: map['sdp'], type: map['type']);
// }

// class CallDocument {
//   final String callId;
//   final String callerId;
//   final String receiverId;
//   final SessionDescription sessionDescription;
//   final bool isVideoCall;

//   CallDocument({
//     required this.callId,
//     required this.callerId,
//     required this.receiverId,
//     required this.sessionDescription,
//     required this.isVideoCall,
//   });

//   Map<String, dynamic> toMap() => {
//     'callId': callId,
//     'callerId': callerId,
//     'receiverId': receiverId,
//     'sdp': sessionDescription.sdp,
//     'type': sessionDescription.type,
//     'isVideoCall': isVideoCall,
//     'createdAt': FieldValue.serverTimestamp(),
//   };

//   factory CallDocument.fromMap(Map<String, dynamic> map) => CallDocument(
//     callId: map['callId'] ?? '',
//     callerId: map['callerId'],
//     receiverId: map['receiverId'],
//     sessionDescription: SessionDescription(sdp: map['sdp'], type: map['type']),
//     isVideoCall: map['isVideoCall'],
//   );
// }

// class IceCandidateData {
//   final String candidate;
//   final String? sdpMid;
//   final int? sdpMLineIndex;
//   final String from;

//   IceCandidateData({required this.candidate, required this.sdpMid, required this.sdpMLineIndex, required this.from});

//   Map<String, dynamic> toMap() => {
//     'candidate': candidate,
//     'sdpMid': sdpMid,
//     'sdpMLineIndex': sdpMLineIndex,
//     'from': from,
//   };

//   factory IceCandidateData.fromMap(Map<String, dynamic> map) => IceCandidateData(
//     candidate: map['candidate'],
//     sdpMid: map['sdpMid'],
//     sdpMLineIndex: map['sdpMLineIndex'],
//     from: map['from'],
//   );
// }
