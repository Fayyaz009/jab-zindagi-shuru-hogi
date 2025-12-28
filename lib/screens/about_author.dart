import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class AboutAuthorScreen extends StatelessWidget {
  final AppThemeType themeType;

  const AboutAuthorScreen({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // ================= COLORS FROM THEME =================
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color textColor = colorScheme.onSurface;

    // ================= RESPONSIVE VALUES =================
    final double horizontalPadding = width * 0.06;
    final double verticalPadding = height * 0.03;
    final double maxContentWidth = width > 600 ? 650 : double.infinity;

    final double nameFontSize = width < 360 ? 22 : 26;
    final double tagFontSize = width < 360 ? 14 : 16;
    final double bodyFontSize = width < 360 ? 16 : 18;

    final double avatarRadius = width < 360
        ? 48
        : width < 600
        ? 60
        : 70;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          "مصنف کے بارے میں",
          style: TextStyle(
            fontFamily: 'Urdu',
            fontSize: width < 360 ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ================= AUTHOR IMAGE =================
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: const AssetImage('assets/images/author.png'),
                ),

                SizedBox(height: height * 0.03),

                // ================= AUTHOR NAME =================
                Text(
                  'ابو یحیٰ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                SizedBox(height: height * 0.012),

                // ================= TAGLINE =================
                Text(
                  "ناول نگار | افسانہ نویس | مفکر",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: tagFontSize,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),

                SizedBox(height: height * 0.04),

                // ================= ABOUT AUTHOR TEXT =================
                Text(
                  '''ابو یحییٰ پاکستان سے تعلق رکھنے والے ایک عالم اور مصنف ہیں۔ انہوں نے ڈیڑھ درجن سے زائد کتابیں لکھی ہیں جو مجموعی طور پر لاکھوں کی تعداد میں شائع ہو چکی ہیں۔ ان کی سب سے مشہور کتاب ”جب زندگی شروع ہوگی“ ہے جو اردو کی سب سے زیادہ پڑھی جانے والی کتابوں میں سے ایک ہے۔ اس کے علاوہ ابو یحییٰ کی دیگر کتابیں بھی پاکستان کے باہر اردو اور دیگر زبانوں میں شائع ہوئی ہیں، جبکہ ملک کے اندر اور باہر کتاب کی غیر قانونی طباعت کو الگ رکھیں تو۔ یہ کتاب کئی مقامی اور غیر ملکی زبانوں میں ترجمہ ہو چکی ہے؛ جن میں اسی کتاب کا انگریزی ترجمہ ”When Life Begins“ پاکستان اور بیرون ملک بہت پھیلا۔ دونوں کتابیں ای بک کی شکل میں مفت دستیاب ہیں اور انٹرنیٹ پر موجود ہیں۔

”جب زندگی شروع ہوگی“ کی تالیف کے دوران مصنف کو اللہ تعالیٰ نے شادی کے طویل عرصے بعد اولاد سے نوازا۔ عرب روایت کے مطابق انہوں نے ابو یحییٰ کی کنیت اختیار کی اور اسی نام سے کتاب شائع کی جسے اللہ تعالیٰ نے غیر معمولی شہرت عطا فرمائی۔ اس سے قبل ابو یحییٰ اپنے اصل نام ریحان احمد یوسفی سے لکھا کرتے تھے۔

ابو یحییٰ نے کراچی سے اسلامیات اور کمپیوٹر ٹیکنالوجی میں بیچلرز (آنرز) اور ماسٹرز فرسٹ کلاس فرسٹ پوزیشن کے ساتھ حاصل کیے جبکہ سوشل سائنسز میں ایم فل بھی کیا۔ انہوں نے اسلامیات میں پی ایچ ڈی مکمل کی۔ ان کا پی ایچ ڈی مقالہ کا موضوع ’Evolution of Dawah Methodology Literature in 20th Century Subcontinent‘ تھا۔

ابو یحییٰ کئی سالوں سے قرآن مجید پر لیکچرز دے رہے ہیں۔ گزشتہ پندرہ سالوں سے قرآن مجید پر تحقیق کر رہے ہیں جس کا مقصد قرآن کی جامعیت، عقلیت اور مطالبات کو منظم طور پر پیش کرنا ہے۔ قرآن پر ان کا کام ’مضامین قرآن‘ کے نام سے جاری ہے۔''',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: bodyFontSize,
                    height: 1.9,
                    color: textColor,
                  ),
                ),

                SizedBox(height: height * 0.06),

                // ================= FOOTER =================
                Text(
                  "✦ ادب دل کی آواز ہوتا ہے ✦",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 14 : 16,
                    fontStyle: FontStyle.italic,
                    color: textColor.withValues(alpha: 0.6),
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
