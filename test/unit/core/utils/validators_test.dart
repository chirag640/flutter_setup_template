import 'package:flutter_test/flutter_test.dart';
import 'package:setup/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('isNotEmpty validates meaningful content', () {
      expect(Validators.isNotEmpty('hello'), isTrue);
      expect(Validators.isNotEmpty('  spaced  '), isTrue);
      expect(Validators.isNotEmpty('   '), isFalse);
      expect(Validators.isNotEmpty(null), isFalse);
    });

    test('isEmail detects valid addresses', () {
      expect(Validators.isEmail('user@example.com'), isTrue);
      expect(Validators.isEmail('invalid@domain'), isFalse);
      expect(Validators.isEmail(''), isFalse);
      expect(Validators.isEmail(null), isFalse);
    });

    test('hasMinLength enforces minimum characters', () {
      expect(Validators.hasMinLength('password', 8), isTrue);
      expect(Validators.hasMinLength('short', 8), isFalse);
      expect(Validators.hasMinLength(null, 1), isFalse);
    });

    test('isStrongPassword requires length and diversity', () {
      expect(Validators.isStrongPassword('Password1'), isTrue);
      expect(Validators.isStrongPassword('password1'), isFalse);
      expect(Validators.isStrongPassword('PASSWORD1'), isFalse);
      expect(Validators.isStrongPassword('Password'), isFalse);
    });
  });
}
