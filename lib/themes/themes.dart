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
  // 🌙 DARK THEME — Premium Night Reading
  // ============================================================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0D102A),

    primaryColor: const Color(0xFFC9A24D), // muted gold

    cardColor: const Color(0xFF1A1F3C),

    iconTheme: const IconThemeData(color: Color(0xFFB0B3C7)),

    dividerColor: Colors.white24,

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Color(0xFFECECEC),
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Color(0xFFE0E0E0),
        fontFamily: 'Urdu',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFFB0B3C7),
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFC9A24D),
      linearTrackColor: Color(0xFF2A2F55),
    ),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFC9A24D),
      secondary: Color(0xFF5C6BC0),
      tertiary: Color(0xFF1A1F3C),
      surface: Color(0xFF0D102A),
      onSurface: Color(0xFFECECEC),
      onPrimary: Color(0xFF3E2723),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0x33C9A24D),
      cursorColor: Color(0xFFC9A24D),
      selectionHandleColor: Color(0xFFC9A24D),
    ),
  );

  // ============================================================
  // ☀️ LIGHT THEME — Clean & Modern
  // ============================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFFFFFFF),

    primaryColor: const Color(0xFF222222),

    cardColor: const Color(0xFFF4F4F4),

    iconTheme: const IconThemeData(color: Color(0xFF616161)),

    dividerColor: const Color(0xFFE0E0E0),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Color(0xFF222222),
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Color(0xFF333333),
        fontFamily: 'Urdu',
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF616161),
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF222222),
      linearTrackColor: Color(0xFFE0E0E0),
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF222222),
      secondary: Color(0xFF9E9E9E),
      tertiary: Color(0xFFE0E0E0),
      surface: Colors.white,
      onSurface: Color(0xFF222222),
      onPrimary: Colors.white,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0x33222222),
      cursorColor: Color(0xFF222222),
      selectionHandleColor: Color(0xFF222222),
    ),
  );

  // ============================================================
  // 📜 SEPIA THEME — PERFECT PAPER MATCH
  // ============================================================
  static final ThemeData sepiaTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF4E8C1), // paper base

    cardColor: const Color(0xFFEAD9AD), // paper surface

    dividerColor: const Color(0xFFC7B28A),

    iconTheme: const IconThemeData(color: Color(0xFF5D4037)),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Urdu',
        fontSize: 24,
        color: Color(0xFF4E342E),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: Color(0xFF4E342E),
        fontFamily: 'Urdu',
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: Color(0xFF5D4037),
        fontFamily: 'Urdu',
        height: 1.7,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF6D4C41),
        fontFamily: 'Urdu',
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFC9A24D), // gold accent
      linearTrackColor: Color(0xFFC7B28A),
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFFC9A24D), // gold
      secondary: Color(0xFFB0893F), // dark gold
      tertiary: Color(0xFFEAD9AD), // paper surface
      surface: Color(0xFFF4E8C1), // background
      onSurface: Color(0xFF4E342E), // text
      onPrimary: Color(0xFF3E2723),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0x33C9A24D),
      cursorColor: Color(0xFF6D4C41),
      selectionHandleColor: Color(0xFF6D4C41),
    ),
  );
}
