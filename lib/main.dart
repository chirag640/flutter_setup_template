import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'core/services/logger_service.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'core/providers/theme_provider.dart';

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
        return ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProv, _) {
              return MaterialApp(
                themeMode: themeProv.themeMode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text('Logger + Theme Demo'),
                    actions: [
                      IconButton(
                        tooltip: 'Toggle Theme',
                        icon: Icon(themeProv.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
                        onPressed: () => themeProv.toggleTheme(),
                      ),
                    ],
                  ),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.logi('Button pressed');
                        AppLogger.instance.warning('This is a warning example', tag: 'Demo');
                      },
                      child: const Text('Write Logs'),
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
