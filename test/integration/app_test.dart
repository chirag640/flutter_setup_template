import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:setup/core/services/logger_service.dart';
import 'package:setup/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:setup/features/auth/presentation/pages/login_page.dart';
import 'package:setup/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveTempDir;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    hiveTempDir = await Directory.systemTemp.createTemp('setup_hive_test');
    Hive.init(hiveTempDir.path);
  });

  tearDownAll(() async {
    if (await Hive.boxExists(AuthLocalDataSourceImpl.userBoxKey)) {
      await Hive.deleteBoxFromDisk(AuthLocalDataSourceImpl.userBoxKey);
    }
    await Hive.close();
    if (await hiveTempDir.exists()) {
      await hiveTempDir.delete(recursive: true);
    }
  });

  testWidgets('launches login screen when unauthenticated', (tester) async {
    await AppLogger.instance.init(
      minLogLevel: LogLevel.info,
      enableConsoleLogging: false,
      enableFileLogging: false,
    );

    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
