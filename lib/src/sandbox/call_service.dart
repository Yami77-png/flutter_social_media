import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_social_media/src/features/Chat/application/call_cubit.dart';

class CallService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'call_test';

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? remoteStream;

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    };

    final constraints = <String, dynamic>{
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
      ],
    };

    RTCPeerConnection pc = await createPeerConnection(config, constraints);

    return pc;
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<String> createRoom() async {
    final roomRef = firestore.collection(collectionName).doc();
    final roomId = roomRef.id;
    _peerConnection = await _createPeerConnection();

    _localStream = await _getUserMedia();
    _peerConnection!.addStream(_localStream!);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        FirebaseFirestore.instance.collection(collectionName).doc(roomId).collection('callerCandidates').add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await roomRef.set({
      'offer': {'type': offer.type, 'sdp': offer.sdp},
    });

    // Listen for remote answer
    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data['answer'] != null) {
        final answer = data['answer'];
        RTCSessionDescription remoteDesc = RTCSessionDescription(answer['sdp'], answer['type']);
        await _peerConnection!.setRemoteDescription(remoteDesc);
      }
    });

    // Listen for remote ICE candidates from callee
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          final data = docChange.doc.data();
          if (data != null) {
            RTCIceCandidate candidate = RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            _peerConnection!.addCandidate(candidate);
          }
        }
      }
    });

    return roomId; // return generated room id for caller to share
  }

  Future<bool> joinRoom(String roomId) async {
    final roomRef = firestore.collection(collectionName).doc(roomId);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      print('Room $roomId does not exist');
      return false;
    }

    roomRef.snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;

      final status = data['status'];
      log('Call status changed: $status');

      if (status == CallStatus.declined.name) {
        CallCubit().callDeclined();
      } else if (status == CallStatus.ended.name) {
        CallCubit().callEnded();
      }
    });

    _peerConnection = await _createPeerConnection();
    _localStream = await _getUserMedia();
    _peerConnection!.addStream(_localStream!);

    final data = roomSnapshot.data()!;
    final offer = data['offer'];
    RTCSessionDescription remoteDesc = RTCSessionDescription(offer['sdp'], offer['type']);
    await _peerConnection!.setRemoteDescription(remoteDesc);

    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await roomRef.update({
      'answer': {'type': answer.type, 'sdp': answer.sdp},
    });

    // Send local ICE candidates to Firestore (calleeCandidates)
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        roomRef.collection('calleeCandidates').add({
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    // Listen for remote ICE candidates from callerCandidates
    roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          final data = docChange.doc.data();
          if (data != null) {
            RTCIceCandidate candidate = RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            _peerConnection!.addCandidate(candidate);
          }
        }
      }
    });

    return true;
  }
}
