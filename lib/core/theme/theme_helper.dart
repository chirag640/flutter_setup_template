import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
}

class ThemeHelper {
  // Common decorations
  static InputDecoration input({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  static ButtonStyle primaryButton({EdgeInsetsGeometry? padding}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: AppFonts.s16semibold,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static ButtonStyle secondaryButton({EdgeInsetsGeometry? padding}) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      textStyle: AppFonts.s16semibold,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1B1B1B) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        if (!isDark)
          BoxShadow(
            color: colorWithOpacity(Colors.black, 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }
}

// Utilities for working with opacity/alpha safely across the app.
int opacityToAlpha(double opacity) => (opacity.clamp(0.0, 1.0) * 255).round();

Color colorWithOpacity(Color color, double opacity) {
  return color.withAlpha(opacityToAlpha(opacity));
}
