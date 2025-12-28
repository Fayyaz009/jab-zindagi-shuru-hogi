import 'package:flutter/material.dart';

enum AppThemeType { dark, light, sepia }

class ThemeState {
  final ThemeData themeData;
  final AppThemeType themeType;

  const ThemeState({required this.themeData, required this.themeType});
}

class ThemeLoading extends ThemeState {
  ThemeLoading({required super.themeData, required super.themeType});
}
