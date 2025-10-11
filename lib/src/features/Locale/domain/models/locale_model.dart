import 'package:flutter/material.dart';

class LocaleModel {
  final String languageCode;
  final String? countryCode;

  LocaleModel({required this.languageCode, this.countryCode});

  Locale toLocale() => Locale(languageCode, countryCode);

  factory LocaleModel.fromLocale(Locale locale) {
    return LocaleModel(languageCode: locale.languageCode, countryCode: locale.countryCode);
  }
}
