import 'package:flutter/material.dart';

class AppColors {
  // Brand neon accents
  static const Color neonCyan = Color(0xFF22666B);
  static const Color neonPink = Color(0xFFFF2DAE);
  static const Color neonPurple = Color(0xFF7C4DFF);

  // Light theme palette
  static const Color lightBackground = Color(0xFFF7FAFF);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Colors.black;
  static const Color lightOnPrimary = Colors.black;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnError = Colors.white;

  // Dark theme palette
  static const Color darkBackground = Color(0xFF0A0F1E);
  static const Color darkSurface = Color(0xFF0F1229);
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkError = Color(0xFFFF5A5A);
  static const Color darkOnError = Colors.black;

  // Neutrals
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral800 = Color(0xFF1F2937);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [neonCyan, neonPink],
  );
}