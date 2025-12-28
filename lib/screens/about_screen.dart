import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/theme_colors.dart';

class AboutScreen extends StatelessWidget {
  final AppThemeType themeType;

  const AboutScreen({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors(themeType);

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // 📐 Responsive values
    final double horizontalPadding = width * 0.06;
    final double verticalPadding = height * 0.03;
    final double sectionSpacing = height * 0.045;
    final double maxContentWidth = width > 600 ? 600 : double.infinity;

    final double titleFontSize = width < 360 ? 18 : 20;
    final double bodyFontSize = width < 360 ? 15 : 17;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.bg,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "About",
          style: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
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
                // ================= ABOUT BOOK =================
                _sectionTitle("کتاب کے بارے میں", colors, titleFontSize),
                SizedBox(height: height * 0.02),
                _sectionText(
                  """
"جب زندگی شروع ہوگی" ایک فکری اور روحانی کتاب ہے
جو انسان کو زندگی، موت اور آخرت کے بارے میں
سوچنے کی دعوت دیتی ہے۔

یہ کتاب شور و ہنگامے سے دور،
خاموشی میں خود احتسابی اور
اللہ سے تعلق مضبوط کرنے کی ایک کوشش ہے۔
                  """,
                  colors,
                  bodyFontSize,
                ),

                SizedBox(height: sectionSpacing),

                // ================= ABOUT AUTHOR =================
                _sectionTitle("مصنف کے بارے میں", colors, titleFontSize),
                SizedBox(height: height * 0.02),
                _sectionText(
                  """
ابو یحییٰ ایک معروف دینی و فکری مصنف ہیں
جو نوجوان نسل کو مقصدِ زندگی،
ایمان اور اخلاقی اقدار کی طرف
متوجہ کرنے کے لیے لکھتے ہیں۔
                  """,
                  colors,
                  bodyFontSize,
                ),

                SizedBox(height: sectionSpacing),

                // ================= PURPOSE =================
                _sectionTitle("ایپ کا مقصد", colors, titleFontSize),
                SizedBox(height: height * 0.02),
                _sectionText(
                  """
یہ ایپ اس لیے بنائی گئی ہے تاکہ
قارئین اس کتاب کو آسانی،
سکون اور تسلسل کے ساتھ پڑھ سکیں۔

یہ کوئی تجارتی منصوبہ نہیں،
بلکہ ایک فکری و دینی کوشش ہے۔
                  """,
                  colors,
                  bodyFontSize,
                ),

                SizedBox(height: sectionSpacing),

                // ================= THANKS =================
                _sectionTitle("شکریہ", colors, titleFontSize),
                SizedBox(height: height * 0.02),
                _sectionText(
                  """
تمام تر شکر اللہ تعالیٰ کا ہے۔
اگر اس ایپ یا مواد میں کوئی
کمی یا کوتاہی ہو تو وہ ہماری طرف سے ہے۔
                  """,
                  colors,
                  bodyFontSize,
                ),

                SizedBox(height: height * 0.06),

                // ================= FOOTER =================
                Text(
                  "جزاک اللہ خیراً",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 13 : 14,
                    fontStyle: FontStyle.italic,
                    color: colors.text.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String text, ThemeColors colors, double fontSize) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Urdu',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: colors.text,
      ),
    );
  }

  // ================= SECTION BODY =================
  Widget _sectionText(String text, ThemeColors colors, double fontSize) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: 'Urdu',
        fontSize: fontSize,
        height: 1.85,
        color: colors.text,
      ),
    );
  }
}
