import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class ChapterItem extends StatelessWidget {
  final AppThemeType themeType;
  final String title;
  final IconData icon;
  final double progress;
  final VoidCallback onTap;

  const ChapterItem({
    super.key,
    required this.title,
    required this.icon,
    required this.progress,
    required this.themeType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.of(context).size;
    final width = size.width;

    // 📐 Responsive sizes
    final double iconBoxSize = width < 360
        ? 44
        : width < 600
        ? 50
        : 56;
    final double titleFontSize = width < 360
        ? 16
        : width < 600
        ? 18
        : 20;
    final double verticalPadding = width < 360 ? 10 : 12;

    final Color surface = theme.cardColor;
    final Color primary = colorScheme.primary;
    final Color onSurface = colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: surface,
          child: InkWell(
            onTap: onTap,
            splashColor: primary.withValues(alpha: 0.18),
            highlightColor: primary.withValues(alpha: 0.08),
            child: Padding(
              padding: EdgeInsets.all(verticalPadding),
              child: Row(
                children: [
                  // ================= ICON =================
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Icon(icon, color: primary, size: iconBoxSize * 0.55),
                  ),

                  SizedBox(width: width * 0.04),

                  // ================= TEXT + PROGRESS =================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          textDirection: TextDirection.rtl,
                          style: textTheme.bodyLarge?.copyWith(
                            fontFamily: 'Urdu',
                            fontSize: titleFontSize,
                            color: onSurface,
                          ),
                        ),
                        SizedBox(height: width * 0.02),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: width < 360 ? 5 : 6,
                          borderRadius: BorderRadius.circular(20),
                          backgroundColor: onSurface.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(primary),
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
