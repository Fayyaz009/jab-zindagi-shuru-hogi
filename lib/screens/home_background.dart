import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class HomeBackground extends StatelessWidget {
  final AppThemeType themeType;

  const HomeBackground({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (themeType) {
      case AppThemeType.dark:
        return _darkBackground(colorScheme);

      case AppThemeType.sepia:
        return _sepiaBackground(context);

      case AppThemeType.light:
        return Container(color: theme.scaffoldBackgroundColor);
    }
  }

  // ============================================================
  // 🌙 DARK BACKGROUND — Mystical + Calm
  // ============================================================
  Widget _darkBackground(ColorScheme colorScheme) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorScheme.tertiary, colorScheme.surface],
            ),
          ),
        ),

        // Stars texture
        Positioned.fill(
          child: Image.asset('assets/images/stars_bg.jpg', fit: BoxFit.cover),
        ),

        // Soft blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: colorScheme.surface.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 📜 SEPIA BACKGROUND — Old Parchment (MATCHED)
  // ============================================================
  Widget _sepiaBackground(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Slight adaptive alpha for very small phones
    final double overlayAlpha = width < 360 ? 0.52 : 0.48;

    return Stack(
      children: [
        // Base parchment image
        Positioned.fill(
          child: Image.asset('assets/images/sepia.png', fit: BoxFit.cover),
        ),

        // Warm parchment overlay (key fix)
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF4E8C1).withValues(alpha: overlayAlpha),
          ),
        ),

        // Ultra-soft blur for depth
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
