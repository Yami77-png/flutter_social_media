import 'package:flutter_social_media/src/features/Locale/domain/models/locale_model.dart';

enum SupportedAppLocale {
  english,
  arabic,
  bengali,
  german,
  gujarati,
  hindi,
  japanese,
  marathi,
  malay,
  nepali,
  tamil,
  telugu,
  thai,
}

class AppLocales {
  static final List<LocaleModel> supportedLocales = [
    LocaleModel(languageCode: 'ar', countryCode: 'AR'),
    LocaleModel(languageCode: 'bn', countryCode: 'BN'),
    LocaleModel(languageCode: 'de', countryCode: 'DE'),
    LocaleModel(languageCode: 'en', countryCode: 'US'),
    LocaleModel(languageCode: 'gu', countryCode: 'GU'),
    LocaleModel(languageCode: 'hi', countryCode: 'IN'),
    LocaleModel(languageCode: 'ja', countryCode: 'JP'),
    LocaleModel(languageCode: 'mr', countryCode: 'MR'),
    LocaleModel(languageCode: 'ms', countryCode: 'MS'),
    LocaleModel(languageCode: 'ne', countryCode: 'NE'),
    LocaleModel(languageCode: 'ta', countryCode: 'TA'),
    LocaleModel(languageCode: 'te', countryCode: 'TE'),
    LocaleModel(languageCode: 'th', countryCode: 'TH'),
  ];

  static String getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা';
      case 'de':
        return 'Deutsch';
      case 'gu':
        return 'ગુજરાતી';
      case 'hi':
        return 'हिंदी';
      case 'ja':
        return '日本語';
      case 'mr':
        return 'मराठी';
      case 'ms':
        return 'Bahasa Melayu';
      case 'ne':
        return 'नेपाली';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      case 'th':
        return 'ไทย';
      case 'ar':
        return 'العربية';
      default:
        return languageCode.toUpperCase();
    }
  }
}
