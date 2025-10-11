import 'dart:ui';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';

class LocaleService {
  // Get the saved Locale from HiveHelper
  static Future<Locale?> getLocale() async {
    final code = await HiveHelper.getLanguageCode();
    if (code != null && code.isNotEmpty) {
      return Locale(code);
    }
    return null;
  }

  // Save a new language code using HiveHelper
  static Future<void> saveLocale(Locale locale) async {
    await HiveHelper.saveLanguageCode(locale.languageCode);
  }

  // Clear the saved language code
  static Future<void> clearLocale() async {
    await HiveHelper.clearLanguageCode();
  }
}
