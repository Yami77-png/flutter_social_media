import 'dart:developer';

import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/friends/domain/knot_model.dart';

class KnotsListRepository {
  Future<List<KnotModel>> fetchKnots() async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return [];

      final snapshot = await FirebaseHelper.users.doc(currentUser.uuid).collection('knots').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      final knotsList = snapshot.docs.map((doc) => KnotModel.fromMap(doc.data())).toList();

      log('Successfully fetched ${knotsList.length} knots.');
      return knotsList;
    } catch (e) {
      log('Error fetching requested knots: $e');
      // Re-throw the error to be handled by the cubit
      rethrow;
    }
  }

  Future<List<KnotModel>> fetchRequestedKnots() async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return [];

      final snapshot = await FirebaseHelper.users.doc(currentUser.uuid).collection('requestedKnots').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      final knotsList = snapshot.docs.map((doc) => KnotModel.fromMap(doc.data())).toList();

      log('Successfully fetched ${knotsList.length} requested knots.');
      return knotsList;
    } catch (e) {
      log('Error fetching requested knots: $e');
      // Re-throw the error to be handled by the cubit
      rethrow;
    }
  }

  Future<List<KnotModel>> fetchIncomingKnots() async {
    try {
      final currentUser = await AuthRepository().getCurrentUserData();
      if (currentUser == null) return [];

      final snapshot = await FirebaseHelper.users.doc(currentUser.uuid).collection('incomingKnotRequests').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      final knotsList = snapshot.docs.map((doc) => KnotModel.fromMap(doc.data())).toList();

      log('Successfully fetched ${knotsList.length} incoming knots.');
      return knotsList;
    } catch (e) {
      log('Error fetching requested knots: $e');
      // Re-throw the error to be handled by the cubit
      rethrow;
    }
  }
}
