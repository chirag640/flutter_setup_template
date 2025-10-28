import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';

/// Pumps [child] inside a [MaterialApp] wrapped with [Sizer] to provide
/// responsive metrics in widget tests without risking long settle loops.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  bool wrapWithScaffold = true,
}) async {
  await tester.pumpWidget(
    Sizer(
      builder: (context, orientation, deviceType) {
        final home = wrapWithScaffold ? Scaffold(body: child) : child;
        return MaterialApp(home: home);
      },
    ),
  );

  // Allow a single frame for layout/animations instead of full settle to avoid
  // pump timeouts with responsive widgets.
  await tester.pump(const Duration(milliseconds: 50));
}
