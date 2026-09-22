import 'package:flutter/material.dart';

/// Centralized theme for Credo.
///
/// All colors, elevation values, and text styles are defined here
/// to keep the UI consistent across every platform and screen.
class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // Light Theme Colors
  // ─────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFE8EBF0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightAppBar = Color(0xFF6373BF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // ─────────────────────────────────────────────
  // Dark Theme Colors
  // ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkAppBar = Color(0xFF1F2235);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // ─────────────────────────────────────────────
  // Shared
  // ─────────────────────────────────────────────
  static const Color brandGreen = Color(0xFF22C55E);
  static const double cardRadius = 16.0;

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: brandGreen, brightness: Brightness.light),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightAppBar,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: lightTextPrimary),
        bodySmall: TextStyle(color: lightTextSecondary),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: brandGreen, brightness: Brightness.dark),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkAppBar,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: darkTextPrimary),
        bodySmall: TextStyle(color: darkTextSecondary),
      ),
    );
  }
}
