import 'package:bloc/bloc.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_state.dart';
import 'package:flutter_social_media/src/features/Locale/domain/interface/i_locale_repository.dart';
import 'package:flutter_social_media/src/features/Locale/domain/models/locale_model.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final ILocaleRepository repository;

  LocaleCubit(this.repository) : super(LocaleInitial()) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final locale = await repository.getSavedLocale();
      if (locale != null) {
        emit(LocaleLoadSuccess(locale));
      } else {
        emit(LocaleLoadSuccess(LocaleModel(languageCode: 'en')));
      }
    } catch (e) {
      emit(LocaleLoadFailure(e.toString()));
    }
  }

  Future<void> changeLocale(LocaleModel locale) async {
    emit(LocaleLoadSuccess(locale));
    await repository.saveLocale(locale);
  }

  Future<void> clearLocale() async {
    emit(LocaleLoadSuccess(LocaleModel(languageCode: 'en')));
    await repository.clearLocale();
  }
}
