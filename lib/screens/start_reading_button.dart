import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';

class StartReadingButton extends StatefulWidget {
  final AppThemeType themeType;

  const StartReadingButton({super.key, required this.themeType});

  @override
  State<StartReadingButton> createState() => _StartReadingButtonState();
}

class _StartReadingButtonState extends State<StartReadingButton> {
  bool _isPressed = false;

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
            targetChapter = chapterItems.firstWhere(
              (c) => c['chapterID'] == latestModel.chapterID,
              orElse: () => chapterItems.first,
            );
          }
        }

        // ================= IMPROVED THEME PALETTE =================
        final List<Color> gradientColors = widget.themeType == AppThemeType.dark
            ? const [Color(0xFFD4AF37), Color(0xFF996515)] // Metallic Gold
            : widget.themeType == AppThemeType.sepia
            ? const [Color(0xFFE5C17B), Color(0xFFB0893F)] // Warm Bronze
            : const [Color(0xFFFFD54F), Color(0xFFFBC02D)]; // Vibrant Amber

        final Color textColor = widget.themeType == AppThemeType.dark
            ? const Color(0xFF1A1108)
            : const Color(0xFF3E2723);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
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

            // Show ad AFTER navigation has arrived (longer delay for better experience)
            Future.delayed(const Duration(milliseconds: 1000), () {
              AdService().showInterstitialAd();
            });
          },
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: buttonText == "Continue Reading" ? 280 : 240,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.35),
                    blurRadius: 15,
                    spreadRadius: -2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    // 1. Subtle Glass Shimmer (Light Source)
                    Positioned(
                      top: -10,
                      left: -10,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),

                    // 2. Button Content
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            buttonText == "Continue Reading"
                                ? Icons.menu_book_rounded
                                : Icons.play_arrow_rounded,
                            color: textColor,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            buttonText,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Urdu',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
