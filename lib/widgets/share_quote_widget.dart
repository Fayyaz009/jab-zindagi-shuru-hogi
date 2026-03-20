import 'package:flutter/material.dart';

class ShareQuoteWidget extends StatelessWidget {
  final String quote;
  final String author;

  const ShareQuoteWidget({
    super.key,
    required this.quote,
    this.author = "Jab Zindagi Shuru Hogi",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080, // High res for sharing
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1a2a6c),
            const Color(0xFFb21f1f),
            const Color(0xFFfdbb2d),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Colors.white70,
            size: 80,
          ),
          const SizedBox(height: 30),
          Text(
            quote,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Urdu',
              fontSize: 48,
              color: Colors.white,
              height: 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Container(
            height: 2,
            width: 200,
            color: Colors.white30,
          ),
          const SizedBox(height: 30),
          Text(
            author,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white70,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.library_books, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  "Jab Zindagi Shuru Hogi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
