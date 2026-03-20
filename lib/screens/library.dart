import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/image_share_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/share_quote_widget.dart';

class Library extends StatelessWidget {
  final String title;

  const Library({super.key, required this.title});

  static const List<Map<String, String>> quotes = [
    {
      "title":
          "اور عنقریب تمہارا رب تمہیں اتنا عطا کرے گا کہ تم راضی ہو جاؤ گے۔",
      "author": "Quran 93:5",
    },
    {
      "title":
          "میرے لیے اللہ کافی ہے، اس کے سوا کوئی معبود نہیں، میں نے اسی پر بھروسہ کیا اور وہ عرشِ عظیم کا مالک ہے۔",
      "author": "Quran 9:129",
    },
    {"title": "بیشک تنگی کے ساتھ آسانی ہے۔", "author": "Quran 94:6"},
    {
      "title": "یاد رکھو! اللہ کے ذکر سے ہی دلوں کو اطمینان نصیب ہوتا ہے۔",
      "author": "Quran 13:28",
    },
    {
      "title": "اور جو اللہ پر بھروسہ کرتا ہے تو وہ اس کے لیے کافی ہے۔",
      "author": "Quran 65:3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return BlocSelector<ThemeBloc, ThemeState, AppThemeType>(
      selector: (state) => state.themeType,
      builder: (context, themeType) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: AppDrawer(themeType: themeType),

          // ================= APP BAR =================
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            title: Text(
              title,
              style: textTheme.titleLarge?.copyWith(fontFamily: 'Urdu'),
            ),
          ),

          // ================= BODY =================
          body: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, // responsive side padding
              vertical: height * 0.025,
            ),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];

              return Padding(
                padding: EdgeInsets.only(bottom: height * 0.035),
                child: GlassQuoteCard(
                  title: quote['title']!,
                  author: quote['author']!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// 🧊 GLASS QUOTE CARD — RESPONSIVE & THEME AWARE
class GlassQuoteCard extends StatelessWidget {
  final String title;
  final String author;

  const GlassQuoteCard({super.key, required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Slightly reduce card width on tablets
    final double maxCardWidth = width > 600 ? 520 : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxCardWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(width * 0.055),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.18),
                  width: 1.3,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.onSurface.withValues(alpha: 0.10),
                    colorScheme.onSurface.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                        size: width * 0.07,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.image_outlined,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          size: width * 0.05,
                        ),
                        tooltip: "Share as Image",
                        onPressed: () async {
                          // Show loading
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Preparing Image...")),
                          );

                          final bytes = await ImageShareService.screenshotController
                              .captureFromWidget(
                            ShareQuoteWidget(quote: title, author: author),
                            delay: const Duration(milliseconds: 10),
                          );

                          await ImageShareService.shareImage(bytes, title);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.025),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Urdu',
                      fontSize: width * 0.045,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: width * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "- $author",
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: width * 0.032,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
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
