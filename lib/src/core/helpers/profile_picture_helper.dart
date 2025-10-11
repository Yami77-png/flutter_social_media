import 'dart:developer';

import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/core/helpers/public_avatar_helper.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/friends/infrustructure/knot_repository.dart';
import 'package:flutter_social_media/src/features/settings/domain/models/profile_picture_privacy.dart';

class ProfilePictureHelper {
  final _authRepository = AuthRepository();
  final _knotRepository = KnotRepository();
  final _publicAvatarHelper = PublicAvatarHelper();

  Future<String?> getProfilePictureUrl(String otherUserId, {bool fallbackToPublicAvatarIfNull = false}) async {
    try {
      final currentUserId = await HiveHelper.getCurrentUserId();

      final Userx? otherUser = await _authRepository.getUserDataByUuid(otherUserId);
      if (otherUser == null) return null;

      final isCurrentUser = currentUserId == otherUserId;

      // Always show profile picture for current user and  business, professional, creator user types
      if (isCurrentUser || otherUser.userType != UserType.individual) {
        return otherUser.imageUrl;
      }

      final IndividualProfileModel? otherUserData = await _authRepository.getIndividualUserData(refId: otherUser.refid);

      final privacy = otherUserData?.profilePicturePrivacy ?? ProfilePicturePrivacy.public;
      String? imageUrl;

      switch (privacy) {
        case ProfilePicturePrivacy.public:
          imageUrl = otherUser.imageUrl;
          break;

        case ProfilePicturePrivacy.knots:
          final isKnotted = await _knotRepository.isAlreadyKnotted(otherUserId);
          imageUrl = isKnotted ? otherUser.imageUrl : null;
          break;

        case ProfilePicturePrivacy.onlyMe:
          imageUrl = null;
          break;

        default:
          imageUrl = otherUser.imageUrl;
      }

      // Fallback to Public Avatar
      if ((imageUrl == null && fallbackToPublicAvatarIfNull) || imageUrl == null || imageUrl.isEmpty) {
        return _publicAvatarHelper.getAssetPath(otherUserData?.publicAvatar);
      }

      return imageUrl;
    } catch (e) {
      log('getProfilePictureUrl error: $e');
      return null;
    }
  }
}
