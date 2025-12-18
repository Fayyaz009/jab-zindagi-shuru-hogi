import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class HomeBackground extends StatelessWidget {
  final AppThemeType themeType;

  const HomeBackground({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    if (themeType == AppThemeType.dark) {
      return _darkBackground();
    } else if (themeType == AppThemeType.sepia) {
      return Image.asset(
        'assets/images/sepia.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Container(color: Colors.white);
    }
  }

  Widget _darkBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1B2556), Color(0xFF090A15)],
            ),
          ),
        ),

        Positioned.fill(
          child: Image.asset('assets/images/stars_bg.jpg', fit: BoxFit.cover),
        ),

        /// ✅ blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.15)),
          ),
        ),
      ],
    );
  }
}
