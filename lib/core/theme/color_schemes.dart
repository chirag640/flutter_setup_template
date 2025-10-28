import 'package:flutter/material.dart';
import 'app_colors.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  surface: AppColors.surface,
  error: AppColors.error,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  brightness: Brightness.dark,
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  surface: AppColors.surfaceDark,
  error: AppColors.error,
);
