import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/services/notification_services.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/friends/domain/knot_model.dart';
import 'package:uuid/uuid.dart';

class KnotRepository {
  Future<bool> sendKnotRequest(Userx requestedUser) async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return false;

      //requesting knot
      final knotId = const Uuid().v4();
      KnotModel requestKnot = KnotModel(
        id: knotId,
        userId: requestedUser.uuid,
        name: requestedUser.name,
        imageUrl: requestedUser.imageUrl,
      );

      final currentUserRef = FirebaseHelper.users
          .doc(currentUser.uuid)
          .collection('requestedKnots')
          .doc(requestedUser.uuid);

      await currentUserRef.set(requestKnot.toMap());

      //incoming knot
      KnotModel incomingKnot = KnotModel(
        id: knotId,
        userId: currentUser.uuid,
        name: currentUser.name,
        imageUrl: currentUser.imageUrl,
      );

      final requestedUserRef = FirebaseHelper.users
          .doc(requestedUser.uuid)
          .collection('incomingKnotRequests')
          .doc(currentUser.uuid);

      await requestedUserRef.set(incomingKnot.toMap());
      log('${currentUser.name} sent knot request to ${requestedUser.name}.');

      //Notification
      await NotificationServices().sendNotification(
        receiverUid: requestedUser.uuid,
        type: NotificationType.knotRequest,
        payload: NotificationPayload(
          title: '${currentUser.name} sent you knot request.',
          body: '',
          image: currentUser.imageUrl,
          userId: currentUser.uuid,
        ),
      );

      return true;
    } catch (e, stack) {
      log('Error sending knot request: $e', stackTrace: stack);
      return false;
    }
  }

  Future<bool> hasRequestedKnots(String otherUserId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('Error: No user is currently signed in.');
        return false;
      }

      final requestKnotDocRef = FirebaseHelper.users.doc(currentUser.uid).collection('requestedKnots').doc(otherUserId);

      final docSnapshot = await requestKnotDocRef.get();

      return docSnapshot.exists;
    } catch (e) {
      log('Error checking knot request status: $e');
      return false;
    }
  }

  Future<bool> hasIncomingKnots(String otherUserId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('Error: No user is currently signed in.');
        return false;
      }

      final incomingKnotDocRef = FirebaseHelper.users
          .doc(currentUser.uid)
          .collection('incomingKnotRequests')
          .doc(otherUserId);

      final docSnapshot = await incomingKnotDocRef.get();

      return docSnapshot.exists;
    } catch (e) {
      log('Error checking knot request status: $e');
      return false;
    }
  }

  Future<bool> isAlreadyKnotted(String otherUserId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('Error: No user is currently signed in.');
        return false;
      }

      final knotDocRef = FirebaseHelper.users.doc(currentUser.uid).collection('knots').doc(otherUserId);

      final docSnapshot = await knotDocRef.get();

      return docSnapshot.exists;
    } catch (e) {
      log('Error checking knot: $e');
      return false;
    }
  }

  Future<bool> cancelKnotRequest(String requestedUserId) async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return false;

      //requesting knot
      final currentUserRef = FirebaseHelper.users
          .doc(currentUser.uuid)
          .collection('requestedKnots')
          .doc(requestedUserId);

      await currentUserRef.delete();

      //incoming knot
      final requestedUserRef = FirebaseHelper.users
          .doc(requestedUserId)
          .collection('incomingKnotRequests')
          .doc(currentUser.uuid);

      await requestedUserRef.delete();
      log('Canceled knot request');
      return true;
    } catch (e, stack) {
      log('Error canceling knot request: $e', stackTrace: stack);
      return false;
    }
  }

  Future<bool> rejectKnotRequest(String requestedUserId) async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return false;

      //requesting knot
      final currentUserRef = FirebaseHelper.users
          .doc(currentUser.uuid)
          .collection('incomingKnotRequests')
          .doc(requestedUserId);

      await currentUserRef.delete();

      //incoming knot
      final requestedUserRef = FirebaseHelper.users
          .doc(requestedUserId)
          .collection('requestedKnots')
          .doc(currentUser.uuid);

      await requestedUserRef.delete();
      log('Rejected knot request');
      return true;
    } catch (e, stack) {
      log('Error rejecting knot request: $e', stackTrace: stack);
      return false;
    }
  }

  Future<bool> acceptKnotRequest(String requestedUserId) async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return false;

      //incoming knot
      final requestedUserRef = FirebaseHelper.users.doc(requestedUserId);
      final requestedKnotRef = requestedUserRef.collection('requestedKnots').doc(currentUser.uuid);

      var requestedKnotSnapshot = await requestedKnotRef.get();
      var requestedKnotData = requestedKnotSnapshot.data();

      if (requestedKnotData != null)
        await requestedUserRef.collection('knots').doc(currentUser.uuid).set(requestedKnotData).whenComplete(() {
          requestedKnotRef.delete();
        });

      //requested knot
      final currentUserRef = FirebaseHelper.users.doc(currentUser.uuid);
      final incomingKnotRef = currentUserRef.collection('incomingKnotRequests').doc(requestedUserId);

      var incomingKnotSnapshot = await incomingKnotRef.get();
      var incomingKnotData = incomingKnotSnapshot.data();

      if (incomingKnotData != null)
        await currentUserRef.collection('knots').doc(requestedUserId).set(incomingKnotData).whenComplete(() {
          incomingKnotRef.delete();
        });

      log('Knot request accepted');

      //Notification
      await NotificationServices().sendNotification(
        receiverUid: requestedUserId,
        type: NotificationType.knotRequest,
        payload: NotificationPayload(
          title: '${currentUser.name} has accepted your knot requested.',
          body: '',
          image: currentUser.imageUrl,
          userId: currentUser.uuid,
        ),
      );
      return true;
    } catch (e, stack) {
      log('Error accepting knot request: $e', stackTrace: stack);
      return false;
    }
  }
}
