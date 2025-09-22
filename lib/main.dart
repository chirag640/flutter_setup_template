import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'core/services/logger_service.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.instance.init(
    minLogLevel: LogLevel.debug,
    enableConsoleLogging: true,
    enableFileLogging: true,
    enableCrashlytics: false,
    maxLogFileSize: 5 * 1024 * 1024,
    maxLogFiles: 3,
  );

  AppLogger.instance.info('App starting...', tag: 'Main');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ],
          child: Consumer2<ThemeProvider, LocaleProvider>(
            builder: (context, themeProv, localeProv, _) {
              return MaterialApp(
                locale: localeProv.locale,
                supportedLocales: L10n.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                themeMode: themeProv.themeMode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                home: Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)?.appTitle ?? 'Setup'),
                    actions: [
                      IconButton(
                        tooltip: AppLocalizations.of(context)?.toggleTheme ?? 'Toggle Theme',
                        icon: Icon(themeProv.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                        onPressed: () => themeProv.toggleTheme(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<Locale>(
                          underline: const SizedBox.shrink(),
                          value: localeProv.locale ?? L10n.supportedLocales.first,
                          items: L10n.supportedLocales.map((locale) {
                            return DropdownMenuItem(
                              value: locale,
                              child: Text(locale.languageCode.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (locale) {
                            if (locale != null) localeProv.setLocale(locale);
                          },
                        ),
                      ),
                    ],
                  ),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)?.welcomeMessage ?? ''),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.logi('Button pressed');
                            AppLogger.instance.warning('This is a warning example', tag: 'Demo');
                          },
                          child: Text(AppLocalizations.of(context)?.writeLogs ?? 'Write Logs'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
