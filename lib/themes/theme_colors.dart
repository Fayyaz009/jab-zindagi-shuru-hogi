import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class ThemeColors {
  final Color bg;
  final Color headerBg;
  final Color text;
  final Color icon;

  ThemeColors(AppThemeType themeType)
    : bg = themeType == AppThemeType.dark
          // 🌙 Dark background (deep blue – less strain)
          ? const Color(0xFF0D102A)
          : themeType == AppThemeType.sepia
          // 📜 Sepia paper background
          ? const Color(0xFFF3E6D3)
          // ☀️ Light
          : const Color(0xFFFFFFFF),

      headerBg = themeType == AppThemeType.dark
          // Dark header
          ? const Color(0xFF1A1F3C)
          : themeType == AppThemeType.sepia
          // Sepia header (slightly darker than bg)
          ? const Color(0xFFEAD7B7)
          // Light header
          : const Color(0xFFF6F6F6),

      text = themeType == AppThemeType.dark
          // Soft white (not pure white)
          ? const Color(0xFFECECEC)
          : themeType == AppThemeType.sepia
          // Dark brown (excellent for reading)
          ? const Color(0xFF3E2C1C)
          : const Color(0xFF111111),

      icon = themeType == AppThemeType.dark
          // Muted gold (not shiny yellow)
          ? const Color(0xFFC9A24D)
          : themeType == AppThemeType.sepia
          // Brown-gold (matches paper theme)
          ? const Color(0xFF8B6B4F)
          : const Color(0xFF444444);
}
