import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryStart = Color(0xFF14B8A6); // teal
  static const Color primaryEnd = Color(0xFF2563EB); // blue
  static const Color background = Color(0xFFF3FBF8);

  // Creates a linear gradient used across the app
  static LinearGradient primaryGradient() {
    return const LinearGradient(
      colors: [primaryStart, primaryEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryStart,
      primary: primaryStart,
      secondary: primaryEnd,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      primaryColor: primaryStart,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryStart,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontWeight: FontWeight.w400),
      ).apply(fontFamily: 'Inter'),
    );
  }
}
