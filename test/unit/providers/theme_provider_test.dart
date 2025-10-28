import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:setup/core/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ThemeNotifier toggles theme modes and persists selection', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeNotifierProvider), ThemeMode.system);

    await container
        .read(themeNotifierProvider.notifier)
        .setTheme(ThemeMode.light);
    expect(container.read(themeNotifierProvider), ThemeMode.light);

    await container.read(themeNotifierProvider.notifier).toggleTheme();
    expect(container.read(themeNotifierProvider), ThemeMode.dark);

    final storedPrefs = await SharedPreferences.getInstance();
    expect(storedPrefs.getBool('isDarkMode'), isTrue);
  });
}
