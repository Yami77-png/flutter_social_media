import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';

class IndividualProfileModel {
  final String refId;
  final String? bio;
  final String dob;
  final String gender;
  final String? nickname;
  final String publicAvatar;
  final String? profilePicturePrivacy;
  final String? quality;
  final String? currentAddress;
  final String? hometown;
  final String? collegeName;
  final String? subject;
  final String? currentStatus;

  IndividualProfileModel({
    required this.refId,
    this.bio,
    required this.dob,
    required this.gender,
    this.nickname,
    required this.publicAvatar,
    this.profilePicturePrivacy,
    this.quality,
    this.currentAddress,
    this.hometown,
    this.collegeName,
    this.subject,
    this.currentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'bio': bio,
      'dob': dob,
      'gender': gender,
      'nickname': nickname,
      'publicAvatar': publicAvatar,
      'profilePicturePrivacy': profilePicturePrivacy,
      'quality': quality,
      'currentAddress': currentAddress,
      'hometown': hometown,
      'collegeName': collegeName,
      'subject': subject,
      'currentStatus': currentStatus,
    };
  }

  factory IndividualProfileModel.fromMap(Map<String, dynamic> map) {
    return IndividualProfileModel(
      refId: map['refId'],
      bio: map['bio'],
      dob: map['dob'],
      gender: map['gender'],
      nickname: map['nickname'],
      publicAvatar: map['publicAvatar'],
      profilePicturePrivacy: map['profilePicturePrivacy'] ?? ProfilePicturePrivacy.public.toString(),
      quality: map['quality'],
      currentAddress: map['currentAddress'],
      hometown: map['hometown'],
      collegeName: map['collegeName'],
      subject: map['subject'],
      currentStatus: map['currentStatus'],
    );
  }
}
