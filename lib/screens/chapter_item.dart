import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class ChapterItem extends StatelessWidget {
  final AppThemeType themeType;
  final String title;
  final IconData icon;
  final double progress;
  final VoidCallback onTap; // 1. Add this callback

  const ChapterItem({
    super.key,
    required this.title,
    required this.icon,
    required this.progress,
    required this.themeType,
    required this.onTap, // 2. Require it in constructor
  });

  @override
  Widget build(BuildContext context) {
    // Colors logic remains the same
    final Color bgColor = themeType == AppThemeType.dark
        ? const Color(0xFF1B1B3A)
        : themeType == AppThemeType.sepia
        ? const Color(0xFFE6D3A3)
        : Colors.white;

    final Color iconColor = themeType == AppThemeType.dark
        ? const Color(0xFFFFD700)
        : themeType == AppThemeType.sepia
        ? const Color(0xFF6D4C41)
        : Colors.black87;

    final Color textColor = themeType == AppThemeType.dark
        ? Colors.white
        : themeType == AppThemeType.sepia
        ? const Color(0xFF4E342E)
        : Colors.black87;

    // 3. Structural change for Click Effect
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        // We only keep Shadow and Radius here. Color moves to Material.
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // ClipRRect ensures the ripple effect stays inside rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          color: bgColor, // Background color moves here
          child: InkWell(
            onTap: onTap, // Handle the click
            splashColor: iconColor.withValues(
              alpha: 0.2,
            ), // Custom splash color
            child: Padding(
              padding: const EdgeInsets.all(12), // Padding moves inside InkWell
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Urdu',
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(15),
                          value: progress,
                          minHeight: 6,
                          backgroundColor: themeType == AppThemeType.dark
                              ? Colors.white10
                              : Colors.black12,
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
