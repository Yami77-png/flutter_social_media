import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';

@immutable
class UserProfileArgs {
  final Userx user;
  final IndividualProfileModel? individualProfile;
  final BusinessProfileModel? businessProfile;
  final ProfessionalProfileModel? professionalProfile;
  final ContentCreatorProfileModel? contentCreatorProfile;

  const UserProfileArgs({
    required this.user,
    this.individualProfile,
    this.businessProfile,
    this.professionalProfile,
    this.contentCreatorProfile,
  });
}
