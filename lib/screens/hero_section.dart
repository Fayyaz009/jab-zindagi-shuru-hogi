import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class HeroSection extends StatelessWidget {
  final AppThemeType themeType;

  const HeroSection({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final size = MediaQuery.of(context).size;
    final width = size.width;

    // 📐 Responsive sizes
    final double coverWidth = width < 360
        ? 130
        : width < 600
        ? 170
        : 220;
    final double coverHeight = coverWidth * 1.4;

    final double glowWidth = coverWidth * 0.85;
    final double glowHeight = coverHeight * 0.9;

    // ================= GLOW COLORS =================
    final Color primaryGlow = colorScheme.primary.withValues(alpha: 0.35);
    final Color secondaryGlow = colorScheme.secondary.withValues(alpha: 0.45);

    return Stack(
      alignment: Alignment.center,
      children: [
        // ================= GLOW =================
        Container(
          width: glowWidth,
          height: glowHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primaryGlow,
                blurRadius: coverWidth * 0.18,
                spreadRadius: coverWidth * 0.02,
              ),
              BoxShadow(
                color: secondaryGlow,
                blurRadius: coverWidth * 0.45,
                spreadRadius: coverWidth * 0.08,
                offset: Offset(0, coverWidth * 0.08),
              ),
            ],
          ),
        ),

        // ================= BOOK COVER =================
        Container(
          width: coverWidth,
          height: coverHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(_coverForTheme(themeType)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  // ================= COVER IMAGE =================
  String _coverForTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.dark:
        return 'assets/images/book_cover.png';
      case AppThemeType.sepia:
        return 'assets/images/sepia_cover.png';
      case AppThemeType.light:
        return 'assets/images/light_cover.png';
    }
  }
}
