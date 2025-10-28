import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/demo/widgets_showcase_page.dart';

/// Landing page shown at the root route. Mirrors the previous
/// home scaffold while adding navigation hooks for GoRouter.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = 'home';
  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);
    final l10n = AppLocalizations.of(context);
    const supportedLocales = AppLocalizations.supportedLocales;
    final currentLocale = locale ?? supportedLocales.first;
    final localeMenuItems = supportedLocales
        .map(
          (supportedLocale) => DropdownMenuItem<Locale>(
            value: supportedLocale,
            child: Text(supportedLocale.languageCode.toUpperCase()),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.appTitle ?? 'Setup'),
        actions: [
          IconButton(
            tooltip: l10n?.toggleTheme ?? 'Toggle Theme',
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: currentLocale,
                items: localeMenuItems,
                onChanged: (selected) {
                  if (selected != null && selected != currentLocale) {
                    ref
                        .read(localeNotifierProvider.notifier)
                        .setLocale(selected);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n?.welcomeMessage ?? ''),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.logi('Button pressed');
                    AppLogger.instance.warning(
                      'This is a warning example',
                      tag: 'Demo',
                    );
                  },
                  child: Text(l10n?.writeLogs ?? 'Write Logs'),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.pushNamed(WidgetsRoutePage.routeName),
                  icon: const Icon(Icons.widgets),
                  label: const Text('View Universal Widgets'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Route endpoint for the widgets showcase to keep GoRouter simple
/// while retaining compatibility with existing demo components.
class WidgetsRoutePage extends StatelessWidget {
  const WidgetsRoutePage({super.key});

  static const routeName = 'widgets';
  static const routePath = '/widgets';
  static const routeSegment = 'widgets';

  @override
  Widget build(BuildContext context) => const WidgetsShowcasePage();
}
