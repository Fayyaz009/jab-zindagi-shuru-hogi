import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class Library extends StatelessWidget {
  final AppThemeType themeType;
  final String title;

  // Example data source - you can replace this with data from your BLoC state later
  final List<Map<String, String>> quotes = [
    {
      "title": "اور اس نے آپ کو راستہ بھولا ہوا پایا تو ہدایت بخشی۔",
      "author": "Quran 93:7",
    },
    {"title": "بیشک تنگی کے ساتھ آسانی ہے۔", "author": "Quran 94:6"},
    {
      "title": "اور نیکی کرو، بیشک اللہ نیکی کرنے والوں سے محبت کرتا ہے۔",
      "author": "Quran 2:195",
    },
    {
      "title": "اور وہی بڑا بخشنے والا، بہت محبت کرنے والا ہے۔",
      "author": "Quran 85:14",
    },
    {
      "title":
          "اللہ کی رحمت سے ناامید نہ ہو، بیشک اللہ تمام گناہ معاف کر دیتا ہے، یقیناً وہ بڑا بخشنے والا، نہایت رحم کرنے والا ہے۔",
      "author": "Quran 39:53",
    },
    {
      "title": "اور اللہ بہترین منصوبہ بندی کرنے والا ہے۔",
      "author": "Quran 8:30",
    },
    {
      "title": "اور وہ تمہارے ساتھ ہے جہاں کہیں بھی تم ہو۔",
      "author": "Quran 57:4",
    },
    {
      "title": "بیشک وہ ہمیشہ سے سب کچھ جاننے والا اور بڑی قدرت والا ہے۔",
      "author": "Quran 35:44",
    },
    {
      "title": "اللہ کسی جان پر اس کی طاقت سے زیادہ بوجھ نہیں ڈالتا۔",
      "author": "Quran 2:286",
    },
    {
      "title":
          "اے ایمان والو! اپنے آپ کو اور اپنے اہل و عیال کو اس آگ سے بچاؤ جس کا ایندھن انسان اور پتھر ہیں، جس پر سخت مزاج فرشتے مقرر ہیں جو اللہ کے حکم کی نافرمانی نہیں کرتے اور وہی کرتے ہیں جس کا انہیں حکم دیا جاتا ہے۔",
      "author": "Quran 66:6",
    },
    {
      "title":
          "سوائے ان لوگوں کے جو ایمان لائے اور نیک اعمال کیے، ان کے لیے ایسا اجر ہے جو کبھی ختم نہ ہوگا۔",
      "author": "Quran 84:25",
    },
    {
      "title":
          "سوائے ان لوگوں کے جو ایمان لائے اور نیک عمل کیے اور ایک دوسرے کو حق کی وصیت کی اور ایک دوسرے کو صبر کی تلقین کی۔",
      "author": "Quran 103:3",
    },
    {
      "title":
          "اور صبر اور نماز کے ذریعے مدد چاہو، اور بیشک یہ (نماز) بہت بھاری ہے مگر ان کے لیے جو عاجزی کرنے والے ہیں۔",
      "author": "Quran 2:45",
    },
    {
      "title":
          "جو صبر کرنے والے، سچے، فرمانبردار، اللہ کی راہ میں خرچ کرنے والے اور رات کے آخری پہر میں مغفرت مانگنے والے ہیں۔",
      "author": "Quran 3:17",
    },

    // Add as many as you want, the builder will handle it
  ];

  Library({super.key, required this.themeType, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeBloc, ThemeState, AppThemeType>(
      selector: (state) => state.themeType,
      builder: (context, currentTheme) {
        final bool isDark = currentTheme == AppThemeType.dark;

        final Color textColor = isDark
            ? Colors.white
            : (currentTheme == AppThemeType.sepia
                  ? const Color(0xFF4E342E)
                  : Colors.black87);

        final Color bgColor = isDark
            ? const Color(0xFF0E0E2C)
            : (currentTheme == AppThemeType.sepia
                  ? const Color(0xFFF4E8C1)
                  : Colors.white);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: textColor),
            ),
            centerTitle: true,
            backgroundColor: bgColor,
            title: const Text("Quotes Library"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    themeType == AppThemeType.dark
                        ? Icons.dark_mode
                        : themeType == AppThemeType.light
                        ? Icons.light_mode
                        : Icons.auto_stories,
                    color: textColor,
                  ),
                  onPressed: () {
                    final next = themeType == AppThemeType.dark
                        ? AppThemeType.light
                        : themeType == AppThemeType.light
                        ? AppThemeType.sepia
                        : AppThemeType.dark;

                    context.read<ThemeBloc>().add(ChangeTheme(next));
                  },
                ),
              ),
            ],

            foregroundColor: textColor,
            elevation: 0,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // The count depends dynamically on your list length
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quoteData = quotes[index];

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 25.0,
                ), // Space between cards
                child: _buildGlassCard(
                  context,
                  quoteData['title']!,
                  quoteData['author']!,
                  textColor,
                  isDark,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Extracted widget method for better readability
  Widget _buildGlassCard(
    BuildContext context,
    String title,
    String author,
    Color textColor,
    bool isDark,
  ) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: textColor.withValues(alpha: 0.2), // Used .withValues()
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  textColor.withValues(alpha: 0.1),
                  textColor.withValues(alpha: 0.02),
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: textColor.withValues(alpha: 0.3),
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'Urdu',
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "- $author",
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
