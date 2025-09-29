import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const background = AppColors.lightBackground;
    const surface = AppColors.lightSurface;

    final scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.neonCyan,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.neonPink,
      onSecondary: AppColors.lightOnSecondary,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      surface: surface,
      onSurface: AppColors.lightOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: AppTypography.poppinsTextTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.lightOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 2,
        ),
      ),
      dividerColor: AppColors.neutral200,
      splashColor: AppColors.neonCyan.withValues(alpha: 0.12),
      highlightColor: AppColors.neonPink.withValues(alpha: 0.06),
      canvasColor: surface,
    );
  }

  static ThemeData get darkTheme => neonDarkTheme;

  static ThemeData get neonDarkTheme {
    const background = AppColors.darkBackground;
    const surface = AppColors.darkSurface;

    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.neonCyan,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.neonPink,
      onSecondary: AppColors.darkOnSecondary,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      surface: surface,
      onSurface: AppColors.darkOnSurface,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: AppTypography.poppinsTextTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.neonPurple.withValues(alpha: 0.32),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.darkOnPrimary,
          shadowColor: AppColors.neonCyan,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      sliderTheme: const SliderThemeData(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
    );

    return base.copyWith(
      dividerColor: AppColors.neonPurple.withValues(alpha: 0.24),
      splashColor: AppColors.neonCyan.withValues(alpha: 0.16),
      highlightColor: AppColors.neonPink.withValues(alpha: 0.08),
      canvasColor: surface,
    );
  }
}

final systemUiOverlayStyle =  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
