import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/theme_colors.dart';

class DonateSupportScreen extends StatelessWidget {
  final AppThemeType themeType;

  const DonateSupportScreen({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors(themeType);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // 📐 Responsive values
    final double horizontalPadding = width * 0.06;
    final double verticalPadding = height * 0.03;
    final double sectionSpacing = height * 0.04;
    final double maxContentWidth = width > 600 ? 560 : double.infinity;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.bg,
        iconTheme: IconThemeData(color: colors.text),
        centerTitle: true,
        title: Text(
          "Donate & Support",
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
                // ================= PURPOSE =================
                Text(
                  "منصوبے کے بارے میں",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),

                SizedBox(height: height * 0.02),

                Text(
                  """
یہ ایپ خالصتاً دینی اور فکری مقصد کے تحت بنائی گئی ہے۔
اگر آپ اس منصوبے کو زندہ رکھنے، مزید بہتری لانے یا دوسرے قارئین تک پہنچانے میں تعاون کرنا چاہتے ہیں تو آپ کی معمولی سی مدد بھی ہمارے لیے قیمتی ہے۔
اللہ آپ کو جزائے خیر عطا فرمائے۔
                  """,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 15 : 17,
                    height: 1.9,
                    color: colors.text,
                  ),
                ),

                SizedBox(height: sectionSpacing),

                // ================= PAYMENT METHODS =================
                Text(
                  "مالی تعاون کے ذرائع",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),

                SizedBox(height: height * 0.025),

                _infoTile(
                  title: "EasyPaisa / SadaPay",
                  value: "0313-7104002",
                  colors: colors,
                ),

                SizedBox(height: height * 0.015),

                _infoTile(
                  title: "WhatsApp",
                  value: "0313-7104002",
                  colors: colors,
                ),

                SizedBox(height: height * 0.015),

                _infoTile(
                  title: "Email",
                  value: "fayyazmalik009@gmail.com",
                  colors: colors,
                ),

                SizedBox(height: sectionSpacing),

                // ================= DUA LINE =================
                Text(
                  "اگر آپ مالی تعاون نہیں کر سکتے تو\nہماری کامیابی کے لیے دعا ضرور کریں 🤲",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 13 : 15,
                    fontStyle: FontStyle.italic,
                    height: 1.7,
                    color: colors.text.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= INFO TILE =================
  Widget _infoTile({
    required String title,
    required String value,
    required ThemeColors colors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.text.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.text.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
