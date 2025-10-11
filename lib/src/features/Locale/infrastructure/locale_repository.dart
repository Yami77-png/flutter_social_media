import 'package:flutter_social_media/src/core/services/locale_service.dart';
import 'package:flutter_social_media/src/features/Locale/domain/interface/i_locale_repository.dart';
import 'package:flutter_social_media/src/features/Locale/domain/models/locale_model.dart';

class LocaleRepository implements ILocaleRepository {
  @override
  Future<LocaleModel?> getSavedLocale() async {
    final locale = await LocaleService.getLocale();
    if (locale == null) return null;
    return LocaleModel.fromLocale(locale);
  }

  @override
  Future<void> saveLocale(LocaleModel locale) {
    return LocaleService.saveLocale(locale.toLocale());
  }

  @override
  Future<void> clearLocale() {
    return LocaleService.clearLocale();
  }
}
