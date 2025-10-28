import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/logger_service.dart';

const _storageKey = 'isDarkMode';

/// Exposes a lazily created [SharedPreferences] instance that can be
/// overridden in tests.
final sharedPreferencesProvider = Provider<Future<SharedPreferences>>((ref) {
  return SharedPreferences.getInstance();
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  final prefsFuture = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefsFuture);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._prefsFuture) : super(ThemeMode.system) {
    _loadTheme();
  }

  final Future<SharedPreferences> _prefsFuture;

  Future<void> _loadTheme() async {
    final prefs = await _prefsFuture;
    final stored = prefs.getBool(_storageKey);
    if (stored == null) return;
    if (!mounted) return;
    AppLogger.instance.d(
      'Loaded stored theme: ${stored ? 'dark' : 'light'}',
      tag: runtimeType.toString(),
    );
    state = stored ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    if (!mounted) return;
    final nextMode = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setTheme(nextMode);
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (!mounted) return;
    state = mode;
    final prefs = await _prefsFuture;
    if (!mounted) return;
    await prefs.setBool(_storageKey, mode == ThemeMode.dark);
    AppLogger.instance.i(
      'Theme updated to ${mode.name}',
      tag: runtimeType.toString(),
    );
  }
}
