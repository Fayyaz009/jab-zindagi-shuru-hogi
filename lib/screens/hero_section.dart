import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class HeroSection extends StatelessWidget {
  final AppThemeType themeType;

  const HeroSection({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ===== GLOW =====
        Container(
          height: 220,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeType == AppThemeType.dark
                    ? Colors.cyanAccent.withValues(alpha: 0.4)
                    : themeType == AppThemeType.sepia
                    ? const Color(0xFF6D4C41).withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: themeType == AppThemeType.dark
                    ? Colors.blue.shade900.withValues(alpha: 0.6)
                    : themeType == AppThemeType.sepia
                    ? const Color(0xFF8D6E63).withValues(alpha: 0.5)
                    : Colors.grey.withValues(alpha: 0.4),
                blurRadius: 60,
                spreadRadius: 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),

        // ===== BOOK COVER =====
        Container(
          height: 240,
          width: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                themeType == AppThemeType.dark
                    ? 'images/book_cover.png'
                    : themeType == AppThemeType.sepia
                    ? 'images/sepia_cover.png'
                    : 'images/light_cover.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
