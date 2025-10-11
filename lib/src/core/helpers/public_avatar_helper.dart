import 'package:flutter_social_media/src/core/utility/assets.dart';

class PublicAvatarHelper {
  final Map<String, String> _avatarAssetMap = {
    'male_placeholder_1': Assets.malePlaceholder1Png,
    'male_placeholder_2': Assets.malePlaceholder2Png,
    'male_placeholder_3': Assets.malePlaceholder3Png,
    'male_placeholder_4': Assets.malePlaceholder4Png,
    'male_placeholder_5': Assets.malePlaceholder5Png,
    'male_placeholder_6': Assets.malePlaceholder6Png,
    'male_placeholder_7': Assets.malePlaceholder7Png,
    'male_placeholder_8': Assets.malePlaceholder8Png,
    'male_placeholder_9': Assets.malePlaceholder9Png,
    'male_placeholder_10': Assets.malePlaceholder10Png,

    'female_placeholder_1': Assets.femalePlaceholder1Png,
    'female_placeholder_2': Assets.femalePlaceholder2Png,
    'female_placeholder_3': Assets.femalePlaceholder3Png,
    'female_placeholder_4': Assets.femalePlaceholder4Png,
    'female_placeholder_5': Assets.femalePlaceholder5Png,
    'female_placeholder_6': Assets.femalePlaceholder6Png,
    'female_placeholder_7': Assets.femalePlaceholder7Png,
    'female_placeholder_8': Assets.femalePlaceholder8Png,
    'female_placeholder_9': Assets.femalePlaceholder9Png,
    'female_placeholder_10': Assets.femalePlaceholder10Png,
  };

  String getAssetPath(String? variableName) {
    print('Requested avatar key: $variableName');
    if (!_avatarAssetMap.containsKey(variableName)) {
      print('Key not found, returning default');
    }
    return _avatarAssetMap[variableName] ?? Assets.malePlaceholder1Png;
  }
}
