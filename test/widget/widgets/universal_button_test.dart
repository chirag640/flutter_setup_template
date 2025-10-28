import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:setup/widgets/universal/universal_button.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('UniversalButton', () {
    testWidgets('invokes callback when pressed', (tester) async {
      var pressed = false;

      await pumpApp(
        tester,
        UniversalButton(text: 'Test Button', onPressed: () => pressed = true),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when requested', (tester) async {
      await pumpApp(
        tester,
        const UniversalButton(
          text: 'Loading Button',
          isLoading: true,
          onPressed: null,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });
  });
}
