import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class StartReadingButton extends StatelessWidget {
  const StartReadingButton({super.key, required AppThemeType themeType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFBCAAA4)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.4),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Start Reading",
          style: TextStyle(
            color: Color(0xFF3E2723),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
