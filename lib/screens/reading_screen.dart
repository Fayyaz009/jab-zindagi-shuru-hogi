import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class ReadingScreen extends StatelessWidget {
  final String chapterTitle;
  final String? readingText;
  final AppThemeType themeType;

  const ReadingScreen({
    super.key,
    required this.chapterTitle,
    required this.themeType,
    required this.readingText,
  });

  @override
  Widget build(BuildContext context) {
    // Determine background color based on theme
    final Color bgColor = themeType == AppThemeType.dark
        ? const Color(0xFF090A15)
        : themeType == AppThemeType.sepia
        ? const Color(0xFFF4ECD8)
        : const Color(0xFFF9F9F9);

    final Color textColor = themeType == AppThemeType.dark
        ? Colors.white
        : const Color(0xFF4E342E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          chapterTitle,
          style: TextStyle(fontFamily: 'Urdu', color: textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            // Placeholder text
            readingText ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
              fontFamily: 'Urdu',
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
