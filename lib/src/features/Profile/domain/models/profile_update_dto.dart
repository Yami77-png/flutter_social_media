import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';

class ProfileUpdateDto {
  final String uuid;
  final String refid;
  final String name;
  final String name_lower;
  final String username;
  final String email;
  final UserType userType;
  final String? imageUrl, coverImageUrl;
  final String? publicAvatar;
  final String? profilePicturePrivacy;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String? homeAddress;
  final String? currentAddress;
  final String? ownerName;
  final String? regiNumber;
  final String? foundingDate;
  final String? category;
  final int? teamCount;
  final String? creatorGender;
  final String? professional;
  final String? designation;
  final String? company;
  final String? industry;
  final String? availability;
  final String? bio;
  final String? collegeName;
  final String? subject;
  final String? hometown;
  final String deviceId;

  ProfileUpdateDto({
    required this.uuid,
    required this.refid,
    required this.name,
    required this.name_lower,
    required this.username,
    required this.email,
    required this.userType,
    this.imageUrl,
    this.coverImageUrl,
    this.publicAvatar,
    this.profilePicturePrivacy,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.homeAddress,
    this.currentAddress,
    this.ownerName,
    this.regiNumber,
    this.foundingDate,
    this.category,
    this.teamCount,
    this.creatorGender,
    this.professional,
    this.designation,
    this.company,
    this.industry,
    this.availability,
    this.bio,
    this.collegeName,
    this.subject,
    this.hometown,
    required this.deviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'refid': refid,
      'name': name,
      'name_lower': name.toLowerCase(),
      'username': username,
      'email': email,
      'userType': userType.name,
      'imageUrl': imageUrl,
      'publicAvatar': publicAvatar,
      'profilePicturePrivacy': profilePicturePrivacy,
      'dob': dob,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'homeAddress': homeAddress,
      'currentAddress': currentAddress,
      'ownerName': ownerName,
      'regiNumber': regiNumber,
      'foundingDate': foundingDate,
      'category': category,
      'teamCount': teamCount,
      'creatorGender': creatorGender,
      'professional': professional,
      'designation': designation,
      'company': company,
      'industry': industry,
      'availability': availability,
      'bio': bio,
      'hometown': hometown,
      'collegeName': collegeName,
      'subject': subject,
      'deviceId': deviceId,
      'coverImageUrl': coverImageUrl,
    };
  }
}
