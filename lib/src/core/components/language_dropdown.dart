import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/utility/components/app_locales.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_cubit.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_state.dart';

Widget LanguageDropdownTopRightCorner() {
  return BlocBuilder<LocaleCubit, LocaleState>(
    builder: (context, state) {
      final currentCode = state is LocaleLoadSuccess ? state.locale.languageCode : 'en';

      return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentCode,
            icon: const SizedBox.shrink(),
            isDense: true,
            alignment: Alignment.topRight,
            selectedItemBuilder: (context) {
              return AppLocales.supportedLocales.map((locale) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: Colors.black, size: 20),
                    SizedBox(width: 10),
                    Text(AppLocales.getDisplayName(locale.languageCode), style: const TextStyle(color: Colors.black)),
                  ],
                );
              }).toList();
            },
            items: AppLocales.supportedLocales.map((locale) {
              return DropdownMenuItem<String>(
                value: locale.languageCode,
                child: Text(
                  AppLocales.getDisplayName(locale.languageCode),
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (code) {
              if (code == null) return;
              final newLocale = AppLocales.supportedLocales.firstWhere((e) => e.languageCode == code);
              context.read<LocaleCubit>().changeLocale(newLocale);
            },
          ),
        ),
      );
    },
  );
}
