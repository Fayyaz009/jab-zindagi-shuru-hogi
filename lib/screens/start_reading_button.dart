import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class StartReadingButton extends StatelessWidget {
  final AppThemeType themeType;

  const StartReadingButton({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, state) {
        String buttonText = "Start Reading";
        Map<String, dynamic> targetChapter = chapterItems.firstWhere(
          (c) => c['chapterID'] == 1,
        );

        if (state is ProgressBarLoaded) {
          final validChapters = state.chapterProgress
              .where((m) => m.lastReadAt != null)
              .toList();

          if (validChapters.isNotEmpty) {
            buttonText = "Continue Reading";

            final latestModel = validChapters.reduce(
              (a, b) => a.lastReadAt!.isAfter(b.lastReadAt!) ? a : b,
            );

            try {
              targetChapter = chapterItems.firstWhere(
                (c) => c['chapterID'] == latestModel.chapterID,
              );
            } catch (_) {
              targetChapter = chapterItems.firstWhere(
                (c) => c['chapterID'] == 1,
              );
            }
          }
        }

        // ================= THEME-BASED BUTTON COLORS =================
        final List<Color> gradientColors = themeType == AppThemeType.dark
            ? const [
                Color(0xFFC9A24D), // muted gold
                Color(0xFF8B6B4F), // brown-gold
              ]
            : themeType == AppThemeType.sepia
            ? const [
                Color(0xFFD6B56E), // soft gold
                Color(0xFFC9A24D), // muted gold
              ]
            : const [
                Color(0xFFFFD54F), // light gold
                Color(0xFFFFECB3), // very soft end
              ];

        final Color textColor = themeType == AppThemeType.dark
            ? const Color(0xFF2A1B0F)
            : themeType == AppThemeType.sepia
            ? const Color(0xFF3E2C1C)
            : const Color(0xFF3E2723);

        return GestureDetector(
          onTap: () {
            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReadingScreen(
                  chapterTitle: targetChapter["title"] as String,
                  readingText: targetChapter["readingText"] as String? ?? '',
                  chapterID: targetChapter['chapterID'] as int,
                ),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: buttonText == "Continue Reading" ? 280 : 260,
            height: 52, // ⬅️ slightly slimmer (premium look)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeType == AppThemeType.dark
                      ? Colors.black45
                      : Colors.brown.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18, // ⬅️ thora refined
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urdu',
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
