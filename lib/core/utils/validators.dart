/// Common synchronous validation utilities used across forms and models.
class Validators {
  const Validators._();

  /// Returns true when [value] is neither null nor empty after trimming.
  static bool isNotEmpty(String? value) => value?.trim().isNotEmpty ?? false;

  /// Basic e-mail validator using a lightweight pattern suitable for UI checks.
  static bool isEmail(String? value) {
    if (!isNotEmpty(value)) return false;
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(value!);
  }

  /// Ensures that [value] meets the provided [minLength].
  static bool hasMinLength(String? value, int minLength) {
    if (minLength <= 0) return true;
    return (value ?? '').trim().length >= minLength;
  }

  /// A simple password strength check combining length and character diversity.
  static bool isStrongPassword(String? value) {
    if (!hasMinLength(value, 8)) return false;
    final password = value!;
    final hasUpper = password.contains(RegExp('[A-Z]'));
    final hasLower = password.contains(RegExp('[a-z]'));
    final hasNumber = password.contains(RegExp('[0-9]'));
    return hasUpper && hasLower && hasNumber;
  }
}
