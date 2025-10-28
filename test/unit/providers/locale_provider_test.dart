import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:setup/core/providers/locale_provider.dart';

void main() {
  test('LocaleNotifier updates and clears locale', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(localeNotifierProvider), isNull);

    const locale = Locale('es');
    container.read(localeNotifierProvider.notifier).setLocale(locale);
    expect(container.read(localeNotifierProvider), locale);

    container.read(localeNotifierProvider.notifier).clearLocale();
    expect(container.read(localeNotifierProvider), isNull);
  });
}
