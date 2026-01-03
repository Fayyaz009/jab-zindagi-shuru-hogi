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
                  " ایپ کے مقاصد",
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
یہ ایپ مکمل طور پر مفت ہے اور بغیر کسی ادائیگی کے استعمال کی جا سکتی ہے۔
اگر آپ اس منصوبے کو پسند کرتے ہیں اور رضاکارانہ طور پر اس کی سپورٹ کرنا چاہتے ہیں تو آپ کا تعاون ہمارے لیے باعثِ حوصلہ ہوگا۔

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
                  " Disclaimer ",
                  style: TextStyle(
                    fontSize: width < 360 ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: colors.text,
                  ),
                ),

                SizedBox(height: sectionSpacing),
                Text(
                  """ مالی تعاون مکمل طور پر رضاکارانہ ہے۔
ایپ کے تمام فیچرز بغیر کسی ادائیگی کے دستیاب ہیں۔
کسی بھی قسم کی ادائیگی لازمی نہیں اور نہ ہی اس کے بدلے کوئی اضافی سہولت فراہم کی جاتی ہے۔
 """,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: width < 360 ? 18 : 20,
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
                  title: "WhatsApp Support",
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
                  " اگر آپ مالی تعاون نہیں کر سکتے تو بھی ایپ استعمال کریں اور اپنی قیمتی رائے ضرور دیں — آپ کی سپورٹ ہمارے لیے قیمتی ہے۔",
                  textAlign: TextAlign.justify,
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
