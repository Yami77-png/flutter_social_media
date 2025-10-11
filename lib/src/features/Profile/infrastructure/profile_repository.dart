import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/profile_update_dto.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

class ProfileRepository {
  Future<void> updateUserCoverPicture({required String imagePath}) async {
    try {
      var currentUser = await AuthRepository().getCurrentUserData();
      final storageRef = FirebaseStorage.instance.ref().child('cover_images/${currentUser!.uuid}.jpg');
      await storageRef.putFile(File(imagePath));
      final downloadUrl = await storageRef.getDownloadURL();
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uuid);
      await userDoc.set({'coverImageUrl': downloadUrl}, SetOptions(merge: true));
    } catch (e) {
      print("Error updating cover picture: $e");
      rethrow;
    }
  }

  // Future<void> updateUserProfilePicture({required String uid, required String imagePath}) async {
  //   try {
  //     final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
  //     await storageRef.putFile(File(imagePath));
  //     final downloadUrl = await storageRef.getDownloadURL();

  //     final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  //     await userDoc.set({'imageUrl': downloadUrl}, SetOptions(merge: true));
  //   } catch (e) {
  //     print("Error updating profile picture: $e");
  //     rethrow;
  //   }
  // }

  // Future<String> _uploadImage(String? imagePath, String uid) async {
  //   String imageUrl = "";
  //   if (imagePath != null) {
  //     final storageRef = FirebaseStorage.instance.ref().child('cover_images/$uid.jpg');
  //     await storageRef.putFile(File(imagePath));
  //     imageUrl = await storageRef.getDownloadURL();
  //   }
  //   return imageUrl;
  // }

  // Future<void> updateUserProfile(IndividualProfileDto individualProfile) async {
  //   try {
  //     final user = await AuthRepository().getCurrentUserData();
  //     final docRef = FirebaseHelper.individualProfile.doc(user!.refid);

  //     await docRef.update(individualProfile.toMap());
  //   } catch (e) {
  //     print("Error updating user profile: $e");
  //   }
  // }

  Future<void> updateInsight(String insight) async {
    try {
      var docSnap = await FirebaseHelper.currentUserDoc.get();

      final data = docSnap.data() as Map<String, dynamic>;
      var user = Userx.fromMap(data);
      if (user.userType == UserType.individual) {
        FirebaseHelper.individualProfile.doc(user.refid).update({'bio': insight});
      }
      log("Insight updated to $insight");
    } catch (e) {
      log("Error updating Insight $e");
    }
  }

  Future<bool> updateUserProfile(ProfileUpdateDto dto) async {
    try {
      final user = Userx(
        uuid: dto.uuid,
        refid: dto.refid,
        deviceId: dto.deviceId,
        name: dto.name,
        name_lower: dto.name.toLowerCase(),
        username: dto.username,
        email: dto.email,
        imageUrl: dto.imageUrl ?? '',
        coverImageUrl: dto.coverImageUrl,
        userType: dto.userType,
        isProfileCompleted: false,
        isVerifed: false,
        phoneNumber: dto.phoneNumber,
      );
      await FirebaseHelper.users.doc(dto.uuid).update(user.toMap());

      String _fallbackAvatar = dto.gender == 'Male' ? Assets.malePlaceholder1Png : Assets.femalePlaceholder1Png;

      switch (dto.userType) {
        case UserType.individual:
          final IndividualProfileModel individual = IndividualProfileModel(
            refId: dto.refid,
            dob: dto.dob ?? '',
            gender: dto.gender ?? '',
            publicAvatar: dto.publicAvatar ?? _fallbackAvatar,
            profilePicturePrivacy: dto.profilePicturePrivacy,
            bio: dto.bio,
            collegeName: dto.collegeName,
            subject: dto.subject,
            currentAddress: dto.currentAddress,
            hometown: dto.hometown,
          );
          await FirebaseHelper.individualProfile.doc(dto.refid).update(individual.toMap());
        case UserType.business:
          final BusinessProfileModel businessProfile = BusinessProfileModel(
            refId: dto.refid,
            currentAddress: dto.currentAddress ?? '',
            ownerName: dto.ownerName ?? '',
            regiNumber: dto.regiNumber ?? '',
          );
          await FirebaseHelper.businessProfile.doc(dto.refid).update(businessProfile.toMap());
        case UserType.contentCreator:
          final ContentCreatorProfileModel contentCreatorProfile = ContentCreatorProfileModel(
            refId: dto.refid,
            category: dto.category ?? '',
            currentAddress: dto.currentAddress ?? '',
            foundingDate: dto.foundingDate ?? '',
            gender: dto.gender ?? '',
            ownerName: dto.ownerName ?? '',
            teamCount: dto.teamCount ?? 0,
          );
          await FirebaseHelper.businessProfile.doc(dto.refid).update(contentCreatorProfile.toMap());
        case UserType.professional:
          final ProfessionalProfileModel professionalProfile = ProfessionalProfileModel(
            refId: dto.refid,
            availability: dto.availability ?? '',
            company: dto.company ?? '',
            designation: dto.designation ?? '',
            industry: dto.industry ?? '',
            professional: dto.professional ?? '',
          );
          await FirebaseHelper.businessProfile.doc(dto.refid).update(professionalProfile.toMap());
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
