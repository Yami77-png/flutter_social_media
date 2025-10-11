import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';

class SignupDto {
  final String password;
  final String uuid;
  final String refid;
  final String name;
  final String email;
  final UserType userType;
  final String deviceId;
  final bool isVerifed;
  final bool isProfileCompleted;
  final String? imageUrl;
  final String? publicAvatar;
  final String? phoneNumber;
  final String dob;
  final String gender;
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

  SignupDto({
    required this.password,
    required this.uuid,
    required this.refid,
    required this.name,
    required this.email,
    required this.userType,
    required this.deviceId,
    required this.isVerifed,
    required this.isProfileCompleted,
    this.imageUrl,
    this.publicAvatar,
    required this.dob,
    required this.gender,
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
  });

  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'uuid': uuid,
      'refid': refid,
      'name': name,
      'email': email,
      'userType': userType.name,
      'deviceId': deviceId,
      'isVerifed': isVerifed,
      'isProfileCompleted': isProfileCompleted,
      'imageUrl': imageUrl,
      'publicAvatar': publicAvatar,
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
    };
  }
}
