import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class AppThemes {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return lightTheme;
      case AppThemeType.sepia:
        return sepiaTheme;
      case AppThemeType.dark:
        return darkTheme;
    }
  }

  // ============================================================
  // 🌙 DARK THEME — Mystical Blue / Purple
  // ============================================================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF090A15),

    primaryColor: const Color(0xFFFFD700),

    cardColor: const Color(0xFF1B1B3A),

    iconTheme: const IconThemeData(color: Colors.white70),

    dividerColor: Colors.white24,

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontFamily: 'Urdu',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.white70,
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFFFD700),
      linearTrackColor: Color(0xFF2C2C54),
    ),

    // ✅ UPDATED ColorScheme (NO deprecated fields)
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFD700), // gold
      secondary: Color(0xFF4527A0), // glow
      tertiary: Color(0xFF1B2556), // gradient top
      surface: Color(0xFF090A15), // screen base
      onSurface: Colors.white, // text/icons on surface
      onPrimary: Color(0xFF3E2723),
    ),
  );

  // ============================================================
  // ☀️ LIGHT THEME
  // ============================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: Colors.white,

    primaryColor: Colors.black,

    cardColor: const Color(0xFFF2F2F2),

    iconTheme: const IconThemeData(color: Colors.black54),

    dividerColor: Colors.black12,

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontFamily: 'Urdu',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black54,
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.black,
      linearTrackColor: Colors.black12,
    ),

    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Color(0xFFBDBDBD),
      tertiary: Color(0xFFE0E0E0),
      surface: Colors.white,
      onSurface: Colors.black,
      onPrimary: Colors.white,
    ),
  );

  // ============================================================
  // 📜 SEPIA THEME — Old Paper Look
  // ============================================================
  static final ThemeData sepiaTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFF6D4C41),

    primaryColor: const Color(0xFF6D4C41),

    cardColor: const Color(0xFFE6D3A3),

    iconTheme: const IconThemeData(color: Color(0xFF5D4037)),

    dividerColor: const Color(0xFFC7B28A),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Color(0xFF4E342E),
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Color(0xFF5D4037),
        fontFamily: 'Urdu',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF6D4C41),
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF6D4C41),
      linearTrackColor: Color(0xFFC7B28A),
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6D4C41),
      secondary: Color(0xFFD2B48C),
      tertiary: Color(0xFFEAD7A1),
      surface: Color(0xFFF4E8C1),
      onSurface: Color(0xFF4E342E),
      onPrimary: Colors.white,
    ),
  );
}
