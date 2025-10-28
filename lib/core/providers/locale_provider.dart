import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../services/logger_service.dart';

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale?>((
  ref,
) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      AppLogger.instance.w(
        'Attempted to set unsupported locale',
        tag: runtimeType.toString(),
        extra: locale.toString(),
      );
      return;
    }
    if (!mounted) return;
    state = locale;
  }

  void clearLocale() {
    if (!mounted) return;
    state = null;
  }

  Locale get effectiveLocale =>
      state ?? AppLocalizations.supportedLocales.first;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
