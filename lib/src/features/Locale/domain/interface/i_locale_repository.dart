import 'package:flutter_social_media/src/features/Locale/domain/models/locale_model.dart';

abstract class ILocaleRepository {
  Future<LocaleModel?> getSavedLocale();
  Future<void> saveLocale(LocaleModel locale);
  Future<void> clearLocale();
}
