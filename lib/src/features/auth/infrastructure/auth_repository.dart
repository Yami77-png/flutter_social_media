import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_social_media/src/core/helpers/firebase_helper.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/signup_dto.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Todo: Handle account already exists

  @override
  Future<bool> signUp({required SignupDto signupDto}) async {
    try {
      final refId = Uuid().v4();

      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: signupDto.email,
        password: signupDto.password,
      );

      final firebaseUser = userCredential.user;
      await firebaseUser!.sendEmailVerification();

      final uid = firebaseUser.uid;

      String imageUrl = await _uploadImage(signupDto.imageUrl, uid);

      bool isUserCreated = await _createUser(imageUrl, uid, refId, signupDto);

      if (isUserCreated) await _createProfile(signupDto, refId);
      log("RefId: $refId");
      log("Uid: $uid");

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: 'EMAIL_ALREADY_IN_USE',
          message: 'Email already exists. Please use a different one.',
        );
      }
      rethrow;
    } catch (e) {
      log('Signup failed: $e');
      return false;
    }
  }

  Future<void> _createProfile(SignupDto signupDto, String refId) async {
    if (signupDto.userType == UserType.individual) {
      final businessUser = IndividualProfileModel(
        refId: refId,
        currentAddress: signupDto.currentAddress ?? '',
        hometown: signupDto.homeAddress ?? '',
        dob: signupDto.dob,
        gender: signupDto.gender,
        publicAvatar: signupDto.publicAvatar!,
      );

      await FirebaseHelper.individualProfile.doc(refId).set(businessUser.toMap());
    } else if (signupDto.userType == UserType.business) {
      final businessUser = BusinessProfileModel(
        refId: refId,
        ownerName: signupDto.ownerName ?? '',
        regiNumber: signupDto.regiNumber ?? '',
        currentAddress: signupDto.currentAddress ?? '',
      );

      await FirebaseHelper.businessProfile.doc(refId).set(businessUser.toMap());
    } else if (signupDto.userType == UserType.contentCreator) {
      final businessUser = ContentCreatorProfileModel(
        refId: refId,
        ownerName: signupDto.ownerName ?? '',
        currentAddress: signupDto.currentAddress ?? '',
        category: signupDto.category ?? '',
        foundingDate: signupDto.foundingDate ?? '',
        gender: signupDto.creatorGender ?? '',
        teamCount: signupDto.teamCount ?? 0,
      );

      await FirebaseHelper.contentCreatorProfile.doc(refId).set(businessUser.toMap());
    } else if (signupDto.userType == UserType.professional) {
      final businessUser = ProfessionalProfileModel(
        refId: refId,
        availability: signupDto.availability ?? '',
        company: signupDto.company ?? '',
        designation: signupDto.designation ?? '',
        industry: signupDto.industry ?? '',
        professional: signupDto.professional ?? '',
      );

      await FirebaseHelper.professionalProfile.doc(refId).set(businessUser.toMap());
    }
  }

  Future<String> _uploadImage(String? imagePath, String uid) async {
    String imageUrl = "";
    if (imagePath != null) {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      await storageRef.putFile(File(imagePath));
      imageUrl = await storageRef.getDownloadURL();
    }
    return imageUrl;
  }

  Future<String> updateUserImage({required String uid, required String imagePath, bool isCoverImage = false}) async {
    try {
      final newImageUrl = await _uploadImage(imagePath, uid);

      if (newImageUrl.isEmpty) {
        throw Exception("Failed to upload image, URL is empty.");
      }

      final userDocRef = FirebaseHelper.users.doc(uid);

      if (isCoverImage) {
        await userDocRef.update({'coverImageUrl': newImageUrl});
      } else {
        await userDocRef.update({'imageUrl': newImageUrl});
      }

      log('Successfully uploaded and updated imageUrl for user $uid.');

      return '';
    } catch (e) {
      log('Error in updateUserImageUrl flow: $e');
      rethrow;
    }
  }

  Future<bool> _usernameExists(String username) async {
    final snapshot = await FirebaseHelper.users.where('username', isEqualTo: username).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> _createUser(String imageUrl, String uid, String refId, SignupDto dto) async {
    try {
      final usersCollection = FirebaseHelper.users;
      final name = dto.name.trim();

      if (name.isEmpty) {
        throw Exception('Name is required to generate a username');
      }

      // Prepare base username
      String baseUsername = name.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      String finalUsername = baseUsername;
      final random = math.Random();
      int attempts = 0;

      // Check if the username already exists or not
      final existingUsernamesSnapshot = await usersCollection.where('username', isEqualTo: finalUsername).get();

      // Loop to generate unique username
      while (existingUsernamesSnapshot.docs.isNotEmpty || (await _usernameExists(finalUsername))) {
        attempts++;
        final randomNumber = random.nextInt(999) + 1; // 1 to 999
        finalUsername = '${baseUsername}_$randomNumber';

        if (attempts > 30) throw Exception('Too many username attempts');
      }

      final user = Userx(
        imageUrl: imageUrl,
        uuid: uid,
        refid: refId,
        name: dto.name,
        name_lower: dto.name.toLowerCase(),
        username: finalUsername,
        email: dto.email,
        userType: dto.userType,
        deviceId: dto.deviceId,
        isProfileCompleted: false,
        isVerifed: false,
        phoneNumber: dto.phoneNumber,
      );
      await FirebaseHelper.users.doc(uid).set(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User> signin({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(code: 'USER_NULL', message: 'No user found in credential.');
      }

      await HiveHelper.setCurrentUserId(user.uid);

      if (!user.emailVerified) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'EMAIL_NOT_VERIFIED',
          message: 'Email is not verified. Please verify your email before signing in.',
        );
      }

      checkAndUpdateDeviceId(user.uid);

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Signin failed: $e');
    }
  }

  Future<void> checkAndUpdateDeviceId(String userId) async {
    final doc = await FirebaseHelper.users.doc(userId).get();

    final storedDeviceId = (doc.data() as Map<String, dynamic>?)?['deviceId'] as String? ?? '';

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    String? currentDeviceId = await messaging.getToken();

    if (currentDeviceId == null) {
      return;
    }

    if (currentDeviceId != storedDeviceId) {
      await FirebaseHelper.users.doc(userId).update({'deviceId': currentDeviceId});
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log('Password reset email sent to $email');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found with this email.');
      } else if (e.code == 'invalid-email') {
        log('The email address is not valid.');
      } else {
        log('Forgot password failed with FirebaseAuthException: ${e.message}');
      }
      return false;
    } catch (e) {
      log('Forgot password failed: $e');
      return false;
    }
  }

  Future<Userx?> getCurrentUserData() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        log('No user is currently signed in.');
        return null;
      }

      final userDoc = await FirebaseHelper.users.doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        log('User document does not exist in Firestore.');
        return null;
      }

      final data = userDoc.data();
      if (data == null || data is! Map<String, dynamic>) {
        log('Invalid user data format.');
        return null;
      }

      final userx = Userx.fromMap(data);
      return userx;
    } catch (e) {
      log('Failed to fetch current user data: $e');
      return null;
    }
  }

  Future<Userx?> getUserDataByUuid(String uuid) async {
    try {
      if (uuid.isEmpty) {
        log('No user data is requested.');
        return null;
      }
      log(uuid);

      final userDoc = await FirebaseHelper.users.doc(uuid).get();

      if (!userDoc.exists) {
        log('User document does not exist in Firestore.');
        return null;
      }

      final data = userDoc.data();
      if (data == null || data is! Map<String, dynamic>) {
        log('Invalid user data format.');
        return null;
      }

      final userx = Userx.fromMap(data);
      return userx;
    } catch (e) {
      log('Failed to fetch current user data: $e');
      return null;
    }
  }

  Future<IndividualProfileModel?> getIndividualUserData({required String? refId}) async {
    return _getUserDataByTypes<IndividualProfileModel>(refId: refId, userType: UserType.individual);
  }

  Future<BusinessProfileModel?> getBusinessUserData({required String? refId}) async {
    return _getUserDataByTypes<BusinessProfileModel>(refId: refId, userType: UserType.business);
  }

  Future<ProfessionalProfileModel?> getProfessionalUserData({required String? refId}) async {
    return _getUserDataByTypes<ProfessionalProfileModel>(refId: refId, userType: UserType.professional);
  }

  Future<ContentCreatorProfileModel?> getContentCreatorUserData({required String? refId}) async {
    return _getUserDataByTypes<ContentCreatorProfileModel>(refId: refId, userType: UserType.contentCreator);
  }

  Future<T?> _getUserDataByTypes<T>({required String? refId, required UserType userType}) async {
    try {
      if (refId == null) {
        log('No refId provided.');
        return null;
      }

      DocumentReference userDocRef;
      switch (userType) {
        case UserType.individual:
          userDocRef = FirebaseHelper.individualProfile.doc(refId);
          break;
        case UserType.business:
          userDocRef = FirebaseHelper.businessProfile.doc(refId);
          break;
        case UserType.contentCreator:
          userDocRef = FirebaseHelper.contentCreatorProfile.doc(refId);
          break;
        case UserType.professional:
          userDocRef = FirebaseHelper.professionalProfile.doc(refId);
          break;
      }

      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        log('User document does not exist in ${userType.name} collection.');
        return null;
      }

      final data = userDoc.data();
      if (data == null || data is! Map<String, dynamic>) {
        log('Invalid user data format for ${userType.name}.');
        return null;
      }

      switch (userType) {
        case UserType.individual:
          return IndividualProfileModel.fromMap(data) as T;
        case UserType.business:
          return BusinessProfileModel.fromMap(data) as T;
        case UserType.contentCreator:
          return ContentCreatorProfileModel.fromMap(data) as T;
        case UserType.professional:
          return ProfessionalProfileModel.fromMap(data) as T;
      }
    } catch (e) {
      log('Failed to fetch user data for ${userType.name}: $e');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      log('User signed out successfully.');
      return true;
    } catch (e) {
      log('Sign out failed: $e');
      return false;
    }
  }

  @override
  Future<bool> isSignedin() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        log('User signed in: ${user.email}');
        return true;
      } else {
        log('User NOT signed in');
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
