import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/signup_dto.dart';

import '../models/user.dart';

abstract class IAuthRepository {
  Future<bool> signUp({required SignupDto signupDto});
  Future<User> signin({required String email, required String password});
  Future<bool> forgotPassword(String email);
  Future<bool> signOut();
  Future<bool> isSignedin();
  Future<Userx?> getCurrentUserData();
  Future<IndividualProfileModel?> getIndividualUserData({required String? refId});
}
