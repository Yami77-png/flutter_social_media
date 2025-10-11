import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String _boxName = 'appBox';
  static const String _firstTimeKey = 'isFirstTimeUser';
  static const String _userIdKey = 'currentUserId';

  // TODO: Move to a more secure storage solution
  static const String _spotifyAccessTokenKey = 'spotifyAccessToken';
  static const String _spotifyTokenExpiryKey = 'spotifyTokenExpiry';

  static Future<void> hiveOpenBox() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<bool> isFirstTimeUser() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_firstTimeKey, defaultValue: true);
  }

  static Future<void> setFirstTimeComplete() async {
    final box = await Hive.openBox(_boxName);
    await box.put(_firstTimeKey, false);
  }

  static Future<void> setCurrentUserId(String userId) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userIdKey, userId);
  }

  static Future<String?> getCurrentUserId() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_userIdKey);
  }

  //TODO clear on logout
  static Future<void> clearCurrentUserId() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_userIdKey);

    // TODO: Move to a more secure storage solution
    // Spotify token storage
    //   static Future<void> saveSpotifyToken(String token, DateTime expiry) async {
    //     final box = Hive.box(_boxName);
    //     await box.put(_spotifyAccessTokenKey, token);
    //     await box.put(_spotifyTokenExpiryKey, expiry.toIso8601String());
    //   }

    //   static String? getSpotifyToken() {
    //     final box = Hive.box(_boxName);
    //     return box.get(_spotifyAccessTokenKey);
    //   }

    //   static DateTime? getSpotifyTokenExpiry() {
    //     final box = Hive.box(_boxName);
    //     final expiryString = box.get(_spotifyTokenExpiryKey);
    //     if (expiryString == null) return null;
    //     return DateTime.tryParse(expiryString);
    //   }

    //   static Future<void> clearSpotifyToken() async {
    //     final box = Hive.box(_boxName);
    //     await box.delete(_spotifyAccessTokenKey);
    //     await box.delete(_spotifyTokenExpiryKey);
  }

  static getSpotifyTokenEpiry() {}

  static getSpotifyToken() {}

  static saveSpotifyToken(accessToken, DateTime expiry) {}

  // Locale

  static const String _languageCodeKey = 'languageCode';

  // Save language code
  static Future<void> saveLanguageCode(String languageCode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_languageCodeKey, languageCode);
  }

  // Get saved language code. Returns null if not set.
  static Future<String?> getLanguageCode() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_languageCodeKey) as String?;
  }

  // Clear saved language code
  static Future<void> clearLanguageCode() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_languageCodeKey);
  }
}
