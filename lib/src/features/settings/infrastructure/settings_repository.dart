import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/screenshot_privacy.dart';
import 'package:flutter_social_media/src/features/settings/domain/interface/i_settings_repository.dart';

class SettingsRepository implements ISettingsRepository {
  static const String _privacyFieldKey = 'profilePicturePrivacy';
  static const String _screenshotPrivacyKey = 'screenshotPrivacy';

  final AuthRepository _authRepo = AuthRepository();

  // Returns the profile collection for the given user type
  CollectionReference _getProfileCollection(UserType userType) {
    switch (userType) {
      case UserType.individual:
        return FirebaseHelper.individualProfile;
      case UserType.business:
        return FirebaseHelper.businessProfile;
      case UserType.professional:
        return FirebaseHelper.professionalProfile;
      case UserType.contentCreator:
        return FirebaseHelper.contentCreatorProfile;
      default:
        throw Exception('Unknown user type: $userType');
    }
  }

  // Profile Picture Privacy

  @override
  Future<ProfilePicturePrivacy> getCurrentProfilePicturePrivacy() async {
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) throw Exception('User not found');

      if (user.userType != UserType.individual) {
        // Only individual users have profile privacy settings
        return ProfilePicturePrivacy.public;
      }

      final profileCollection = _getProfileCollection(user.userType);
      final profileDoc = await profileCollection.doc(user.refid).get();
      final data = profileDoc.data() as Map<String, dynamic>?;

      if (data == null || !data.containsKey(_privacyFieldKey)) {
        await profileDoc.reference.set({_privacyFieldKey: ProfilePicturePrivacy.public.name}, SetOptions(merge: true));
        return ProfilePicturePrivacy.public;
      }

      final value = data[_privacyFieldKey] as String;
      return ProfilePicturePrivacy.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ProfilePicturePrivacy.public,
      );
    } catch (e, st) {
      log('Error retrieving profile privacy: $e', stackTrace: st);
      return ProfilePicturePrivacy.public;
    }
  }

  @override
  Future<void> updateProfilePicturePrivacy(ProfilePicturePrivacy newPrivacy) async {
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) throw Exception('User not found');

      if (user.userType != UserType.individual) {
        throw Exception('Privacy update not supported for this user type');
      }

      final profileCollection = _getProfileCollection(user.userType);
      final profileDocRef = profileCollection.doc(user.refid);

      await profileDocRef.set({_privacyFieldKey: newPrivacy.name}, SetOptions(merge: true));
    } catch (e, st) {
      log('Error updating profile privacy: $e', stackTrace: st);
      rethrow;
    }
  }

  // Screenshot Privacy

  Future<ScreenshotPrivacy> getCurrentScreenshotPrivacy() async {
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) throw Exception('User not found');

      if (user.userType != UserType.individual) {
        // Only individual users have screenshot privacy settings
        return ScreenshotPrivacy.allow;
      }

      final settingsDoc = FirebaseHelper.individualProfile.doc(user.refid).collection('settings').doc('preferences');

      final doc = await settingsDoc.get();
      final data = doc.data();

      if (data == null || !data.containsKey(_screenshotPrivacyKey)) {
        await settingsDoc.set({_screenshotPrivacyKey: ScreenshotPrivacy.allow.name}, SetOptions(merge: true));
        return ScreenshotPrivacy.allow;
      }

      final value = data[_screenshotPrivacyKey] as String;
      return ScreenshotPrivacy.values.firstWhere((e) => e.name == value, orElse: () => ScreenshotPrivacy.allow);
    } catch (e) {
      log('Error retrieving screenshot privacy: $e');
      return ScreenshotPrivacy.allow;
    }
  }

  Future<void> updateScreenshotPrivacy(ScreenshotPrivacy newPrivacy) async {
    try {
      final user = await _authRepo.getCurrentUserData();
      if (user == null) throw Exception('User not found');

      if (user.userType != UserType.individual) {
        throw Exception('Screenshot privacy setting only available for individual users');
      }

      final settingsDoc = FirebaseHelper.individualProfile.doc(user.refid).collection('settings').doc('preferences');

      await settingsDoc.set({_screenshotPrivacyKey: newPrivacy.name}, SetOptions(merge: true));
    } catch (e) {
      log('Error updating screenshot privacy: $e');
      rethrow;
    }
  }
}
