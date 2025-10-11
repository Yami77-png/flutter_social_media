// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';

class Userx {
  final String uuid;
  final String refid;
  final String name;
  final String name_lower;
  final String username;
  final String email;
  final UserType userType;
  final String deviceId;
  final bool isVerifed;
  final bool isProfileCompleted;
  final String imageUrl;
  final String? phoneNumber;
  final String? myStatus;
  final String? coverImageUrl;

  Userx({
    this.phoneNumber,
    required this.uuid,
    required this.refid,
    required this.name,
    required this.name_lower,
    required this.username,
    required this.email,
    required this.userType,
    required this.deviceId,
    required this.isVerifed,
    required this.isProfileCompleted,
    required this.imageUrl,
    this.coverImageUrl,
    this.myStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'coverImageUrl': coverImageUrl,
      'phoneNumber': phoneNumber,
      'uuid': uuid,
      'refid': refid,
      'name': name,
      'name_lower': name_lower,
      'username': username,
      'email': email,
      'userType': userType.name,
      'deviceId': deviceId,
      'isVerifed': isVerifed,
      'isProfileCompleted': isProfileCompleted,
      'imageUrl': imageUrl,
      'myStatus': myStatus,
    };
  }

  factory Userx.fromMap(Map<String, dynamic> map) {
    return Userx(
      coverImageUrl: map['coverImageUrl'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map["imageUrl"],
      isVerifed: map['isVerifed'],
      isProfileCompleted: map['isProfileCompleted'],
      deviceId: map['deviceId'],
      uuid: map['uuid'],
      refid: map['refid'] ?? '',
      name: map['name'],
      name_lower: map['name_lower'],
      username: map['username'],
      email: map['email'],
      myStatus: map['myStatus'],
      userType: UserType.values.firstWhere((e) => e.name == map['userType'], orElse: () => UserType.individual),
    );
  }

  static Future<Userx?> getCurrentUserx() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();

    if (!userDoc.exists) return null;

    return Userx.fromMap(userDoc.data()!);
  }

  Userx copyWith({
    String? uuid,
    String? refid,
    String? name,
    String? name_lower,
    String? username,
    String? email,
    UserType? userType,
    String? deviceId,
    bool? isVerifed,
    bool? isProfileCompleted,
    String? imageUrl,
    String? phoneNumber,
    String? myStatus,
  }) {
    return Userx(
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      uuid: uuid ?? this.uuid,
      refid: refid ?? this.refid,
      name: name ?? this.name,
      name_lower: name_lower ?? this.name_lower,
      username: username ?? this.username,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      deviceId: deviceId ?? this.deviceId,
      isVerifed: isVerifed ?? this.isVerifed,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      myStatus: myStatus ?? this.myStatus,
    );
  }
}

enum UserType {
  individual,
  business,
  contentCreator,
  professional;

  String localizedName(AppLocalizations localizations) {
    switch (this) {
      case UserType.individual:
        return localizations.individual;
      case UserType.business:
        return localizations.business;
      case UserType.contentCreator:
        return localizations.contentCreator;
      case UserType.professional:
        return localizations.professional;
    }
  }
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.individual:
        return 'Individual';
      case UserType.business:
        return 'Business';
      case UserType.contentCreator:
        return 'Content Creator';
      case UserType.professional:
        return 'Professional';
    }
  }
}

enum UserStatus { away, work, game, busy }

extension UserStatusExtension on UserStatus {
  String get text {
    switch (this) {
      case UserStatus.away:
        return 'Away 😊';
      case UserStatus.work:
        return 'At Work 💻';
      case UserStatus.game:
        return 'Game 🎮';
      case UserStatus.busy:
        return 'Busy ❌';
    }
  }
}
