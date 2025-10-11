import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/components/app_locales.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_cubit.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_state.dart';

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final currentLocale = state is LocaleLoadSuccess ? state.locale : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.changeLanguage, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16.h),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: currentLocale?.languageCode,
                icon: const Icon(Icons.arrow_drop_down),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
                  ),
                ),
                items: AppLocales.supportedLocales.map((locale) {
                  final code = locale.languageCode;
                  final name = AppLocales.getDisplayName(code);
                  return DropdownMenuItem<String>(value: code, child: Text(name));
                }).toList(),
                onChanged: (selectedCode) {
                  if (selectedCode == null) return;
                  final newLocale = AppLocales.supportedLocales.firstWhere((l) => l.languageCode == selectedCode);
                  context.read<LocaleCubit>().changeLocale(newLocale);
                },
              ),
            ),
            if (state is LocaleLoadFailure)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error loading locale: ${state.error}', style: const TextStyle(color: Colors.red)),
              ),
          ],
        );
      },
    );
  }
}
