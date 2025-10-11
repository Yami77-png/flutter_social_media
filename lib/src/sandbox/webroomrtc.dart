import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_social_media/src/core/presentation/bootstrap.dart';
import 'package:flutter_social_media/src/features/Chat/application/call_cubit.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:uuid/uuid.dart';

class WebRTCRoomService {
  final FirebaseFirestore _firestore;
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, RTCVideoRenderer> _localRenderers = {};
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};

  WebRTCRoomService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createRoom({required bool isVideo, required String receiverId}) async {
    final callId = const Uuid().v4();
    final roomRef = _firestore.collection('call_test').doc(callId);

    print('==CALLID: $callId');

    var deviceTOKEN = await getDeviceToken(receiverId);

    final pc = await _createPeerConnection(callId);
    _peerConnections[callId] = pc;

    final localRenderer = RTCVideoRenderer();
    await localRenderer.initialize();
    final localStream = await _getUserMedia(isVideo);
    localRenderer.srcObject = localStream;
    _localRenderers[callId] = localRenderer;

    localStream.getTracks().forEach((track) {
      pc.addTrack(track, localStream);
    });

    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    await roomRef.set({
      'offer': {'sdp': offer.sdp, 'type': offer.type},
      'status': CallStatus.ringing.name,
    });

    listenToRoomStatus(callId, pc);

    _firestore.collection('call_test/$callId/candidates').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          final data = docChange.doc.data();
          final candidate = RTCIceCandidate(data!['candidate'], data['sdpMid'], data['sdpMLineIndex']);
          pc.addCandidate(candidate);
        }
      }
    });

    final user = await AuthRepository().getCurrentUserData();

    await sendFCMToCall(
      callId: callId,
      callerId: '${user?.uuid}',
      callerName: '${user?.name}',
      callerImage: '${user?.imageUrl}',
      isVideoCall: isVideo,
      // receiverFcmToken: deviceTOKEN!,
      token: deviceTOKEN!,
      type: 'call',
    );

    print('================ callID: $callId, callerId: ${user?.uuid}, name: ${user?.name}, image: ${user?.imageUrl}');
    return callId;
  }

  void listenToRoomStatus(String callId, RTCPeerConnection pc) {
    final roomRef = FirebaseFirestore.instance.collection('call_test').doc(callId);
    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data == null) return;

      if (data['answer'] != null) {
        final answer = data['answer'];
        final desc = RTCSessionDescription(answer['sdp'], answer['type']);
        await pc.setRemoteDescription(desc);
        updateCallStatus(callId: callId, status: CallStatus.answered.name);
        log("Call was answered.");
      }

      if (data['status'] == CallStatus.declined.name) {
        log("Call was declined.");
      } else if (data['status'] == CallStatus.ended.name) {
        log("Call was ended.");
      }
    });
  }

  Future<void> endCall(String callId, String status) async {
    log('endCall($callId) called');
    updateCallStatus(callId: callId, status: CallStatus.ended.name);
    // log('call status updated: ended');
    await _peerConnections[callId]?.close();
    _peerConnections.remove(callId);
    await _localRenderers[callId]?.dispose();
    await _remoteRenderers[callId]?.dispose();
    _localRenderers.remove(callId);
    _remoteRenderers.remove(callId);

    // await _firestore.collection('calls').doc(callId).delete();
  }

  Future<void> updateCallStatus({required String callId, required String status}) async {
    final roomRef = FirebaseFirestore.instance.collection('call_test').doc(callId);
    await roomRef.update({'status': status});
    log('call status updated: $status');
  }

  Future<String?> getDeviceToken(String receiverId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(receiverId).get();
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['deviceId'];
      }
    } catch (e) {
      print('Error getting device token: $e');
    }
    return null;
  }

  Future<void> joinRoom(String roomId, {bool video = true}) async {
    print('call joined');
    setupCallkitListeners();
    final roomRef = _firestore.collection('call_test').doc(roomId);
    final roomSnapshot = await roomRef.get();
    final data = roomSnapshot.data();
    if (data == null || data['offer'] == null) return;

    final pc = await _createPeerConnection(roomId);
    _peerConnections[roomId] = pc;

    final localRenderer = RTCVideoRenderer();
    await localRenderer.initialize();
    final localStream = await _getUserMedia(video);
    localRenderer.srcObject = localStream;
    _localRenderers[roomId] = localRenderer;

    localStream.getTracks().forEach((track) {
      pc.addTrack(track, localStream);
    });

    final offer = data['offer'];
    await pc.setRemoteDescription(RTCSessionDescription(offer['sdp'], offer['type']));

    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);

    await roomRef.update({
      'answer': {'sdp': answer.sdp, 'type': answer.type},
    });

    _firestore.collection('call_test/$roomId/candidates').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          final data = docChange.doc.data();
          final candidate = RTCIceCandidate(data!['candidate'], data['sdpMid'], data['sdpMLineIndex']);
          pc.addCandidate(candidate);
        }
      }
    });
  }

  Future<RTCPeerConnection> _createPeerConnection(String callId) async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    final pc = await createPeerConnection(config);

    pc.onIceCandidate = (candidate) {
      _firestore.collection('call_test/$callId/candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    pc.onTrack = (event) async {
      if (event.streams.isNotEmpty) {
        final remoteRenderer = RTCVideoRenderer();
        await remoteRenderer.initialize();
        remoteRenderer.srcObject = event.streams[0];
        _remoteRenderers[callId] = remoteRenderer;
      }
    };

    return pc;
  }

  Future<MediaStream> _getUserMedia(bool video) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': video ? {'facingMode': 'user'} : false,
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  RTCVideoRenderer? getLocalRenderer(String callId) => _localRenderers[callId];
  RTCVideoRenderer? getRemoteRenderer(String callId) => _remoteRenderers[callId];

  Future<void> dispose(String callId) async {
    await _peerConnections[callId]?.close();
    _peerConnections.remove(callId);

    await _localRenderers[callId]?.dispose();
    await _remoteRenderers[callId]?.dispose();
    _localRenderers.remove(callId);
    _remoteRenderers.remove(callId);
  }

  // Future<void> sendFCMToCall({
  //   required String callId,
  //   required String callerId,
  //   required String callerName,
  //   required String callerImage,
  //   required String receiverFcmToken,
  //   required bool isVideoCall,
  // }) async {
  //   final uri = Uri.parse('');

  //   final response = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'token': receiverFcmToken,
  //       'type': 'call',
  //       'callId': callId,
  //       'callerId': callerId,
  //       'callerName': callerName,
  //       'callerImage': callerImage,
  //       'isVideoCall': isVideoCall.toString(),
  //       'isCaller': false,
  //     }),
  //   );

  //   if (response.statusCode != 200) {
  //     print('❌ FCM send failed: ${response.statusCode} ${response.body}');
  //   } else {
  //     print('✅ FCM sent to $receiverFcmToken');
  //   }
  // }

  Future<void> sendFCMToCall({
    required String token, // receiver's FCM token
    required String type, // "chat" or "call"
    // chat fields
    String? chatId,
    String? senderId,
    String? message,
    // call fields
    String? callId,
    String? callerId,
    String? callerName,
    String? callerImage,
    bool? isVideoCall,
    bool? isCaller,
  }) async {
    final uri = Uri.parse(''); // TODO: Add URL

    // Prepare base request
    final Map<String, dynamic> body = {'token': token, 'type': type};

    // Append additional fields based on type
    if (type == 'chat') {
      if (chatId == null || senderId == null || message == null) {
        throw ArgumentError('Missing chat fields');
      }
      body.addAll({'chatId': chatId, 'senderId': senderId, 'message': message});
    } else if (type == 'call') {
      // if (callId == null ||
      //     callerId == null ||
      //     callerName == null ||
      //     callerImage == null ||
      //     isVideoCall == null ||
      //     isCaller == null) {
      //   throw ArgumentError('Missing call fields');
      // }
      body.addAll({
        'callId': callId,
        'callerId': callerId,
        'callerName': callerName,
        'callerImage': callerImage,
        'isVideoCall': isVideoCall.toString(),
        'isCaller': isCaller.toString(),
      });
    } else {
      throw ArgumentError("Invalid type: must be 'chat' or 'call'");
    }

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode != 200) {
      log('❌ Failed to send $type notification: ${response.statusCode} ${response.body}');
    } else {
      log('✅ $type notification sent to $token');
    }
  }
}
