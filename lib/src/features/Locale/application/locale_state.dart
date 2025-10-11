import 'package:flutter_social_media/src/features/Locale/domain/models/locale_model.dart';

abstract class LocaleState {}

class LocaleInitial extends LocaleState {}

class LocaleLoadSuccess extends LocaleState {
  final LocaleModel locale;

  LocaleLoadSuccess(this.locale);
}

class LocaleLoadFailure extends LocaleState {
  final String error;

  LocaleLoadFailure(this.error);
}
