import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'theme_helper.dart';

class AppTheme {
	static ThemeData get light => _base(Brightness.light);
	static ThemeData get dark => _base(Brightness.dark);

	static ThemeData _base(Brightness brightness) {
		final bool isDark = brightness == Brightness.dark;
		final colorScheme = isDark
				? ColorScheme.fromSeed(
						seedColor: AppColors.primary,
						brightness: Brightness.dark,
						primary: AppColors.primary,
						secondary: AppColors.secondary,
						surface: AppColors.surfaceDark,
						error: AppColors.error,
					)
				: ColorScheme.fromSeed(
						seedColor: AppColors.primary,
						brightness: Brightness.light,
						primary: AppColors.primary,
						secondary: AppColors.secondary,
						surface: AppColors.surface,
						error: AppColors.error,
					);

		final textTheme = TextTheme(
			displayLarge: AppFonts.s24bold,
			displayMedium: AppFonts.s24semibold,
			displaySmall: AppFonts.s20bold,
			headlineMedium: AppFonts.s20semibold,
			headlineSmall: AppFonts.s18bold,
			titleLarge: AppFonts.appBarTitle,
			titleMedium: AppFonts.s16semibold,
			titleSmall: AppFonts.s14semibold,
			bodyLarge: AppFonts.s16regular,
			bodyMedium: AppFonts.s14regular,
			bodySmall: AppFonts.s12regular,
			labelLarge: AppFonts.s14semibold,
			labelMedium: AppFonts.s12medium,
			labelSmall: AppFonts.s10medium,
		).apply(
			bodyColor: isDark ? Colors.white : AppColors.textPrimary,
			displayColor: isDark ? Colors.white : AppColors.textPrimary,
		);

		final inputBorderRadius = BorderRadius.circular(12);

		return ThemeData(
			useMaterial3: true,
			brightness: brightness,
			colorScheme: colorScheme,
			scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
			fontFamily: AppFonts.fontFamily,
			textTheme: textTheme,

			appBarTheme: AppBarTheme(
				backgroundColor: colorScheme.surface,
				foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
				centerTitle: true,
				elevation: 0,
				titleTextStyle: AppFonts.appBarTitle.copyWith(
					color: isDark ? Colors.white : AppColors.textPrimary,
				),
			),

			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: AppColors.primary,
					foregroundColor: Colors.white,
					disabledBackgroundColor: colorWithOpacity(AppColors.primary, 0.5),
					disabledForegroundColor: Colors.white70,
					padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(16),
					),
					textStyle: AppFonts.s16semibold,
				),
			),

			outlinedButtonTheme: OutlinedButtonThemeData(
				style: OutlinedButton.styleFrom(
					foregroundColor: AppColors.primary,
					side: BorderSide(color: AppColors.primary),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(16),
					),
					textStyle: AppFonts.s16semibold,
				),
			),

			textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
					foregroundColor: AppColors.primary,
					textStyle: AppFonts.s14semibold,
				),
			),

			inputDecorationTheme: InputDecorationTheme(
				filled: true,
				fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
				hintStyle: AppFonts.s14regular.copyWith(color: AppColors.textSecondary),
				contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
				border: OutlineInputBorder(
					borderRadius: inputBorderRadius,
					borderSide: BorderSide(color: AppColors.outline),
				),
				enabledBorder: OutlineInputBorder(
					borderRadius: inputBorderRadius,
					borderSide: BorderSide(color: AppColors.outline),
				),
				focusedBorder: OutlineInputBorder(
					borderRadius: inputBorderRadius,
					borderSide: BorderSide(color: AppColors.primary, width: 1.5),
				),
				errorBorder: OutlineInputBorder(
					borderRadius: inputBorderRadius,
					borderSide: BorderSide(color: AppColors.error),
				),
				focusedErrorBorder: OutlineInputBorder(
					borderRadius: inputBorderRadius,
					borderSide: BorderSide(color: AppColors.error, width: 1.5),
				),
			),

			chipTheme: ChipThemeData(
				backgroundColor: colorWithOpacity(isDark ? Colors.white : Colors.black, 0.06),
				padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
				labelStyle: AppFonts.s12medium.copyWith(
					color: isDark ? Colors.white : AppColors.textPrimary,
				),
				selectedColor: colorWithOpacity(AppColors.primary, 0.12),
				secondarySelectedColor: colorWithOpacity(AppColors.secondary, 0.12),
			),

					cardTheme: const CardThemeData(
						elevation: 0,
						margin: EdgeInsets.all(12),
			),

			dividerTheme: DividerThemeData(
				color: AppColors.outline,
				thickness: 1,
				space: 1,
			),

			bottomNavigationBarTheme: BottomNavigationBarThemeData(
				selectedItemColor: AppColors.primary,
				unselectedItemColor: AppColors.textSecondary,
				backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
				type: BottomNavigationBarType.fixed,
			),
		);
	}
}
