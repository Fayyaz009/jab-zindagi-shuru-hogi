import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/about_author.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/about_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/donate_support.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/theme_colors.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/drawer_items.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  final AppThemeType themeType;

  const AppDrawer({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = ThemeColors(themeType);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colors.bg,

          /// ✅ SUBTLE SHADOW (paper depth)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔹 HEADER
              const _DrawerHeader(),

              /// 🔹 MENU (SCROLLABLE)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerItem(
                      icon: Icons.info_outline,
                      title: "About",
                      iconColor: colors.icon,
                      textColor: colors.text,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AboutScreen(themeType: themeType),
                          ),
                        );
                      },
                    ),

                    DrawerItem(
                      icon: Icons.person_outline,
                      title: "About Author",
                      iconColor: colors.icon,
                      textColor: colors.text,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AboutAuthorScreen(themeType: themeType),
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: colors.text.withValues(alpha: 0.15),
                      ),
                    ),

                    DrawerItem(
                      icon: Icons.volunteer_activism_outlined,
                      title: "Donate & Support",
                      iconColor: colors.icon,
                      textColor: colors.text,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DonateSupportScreen(themeType: themeType),
                          ),
                        );
                      },
                    ),

                    DrawerItem(
                      icon: Icons.share_outlined,
                      title: "Share App",
                      iconColor: colors.icon,
                      textColor: colors.text,
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(
                          "میں یہ کتاب پڑھ رہا ہوں:\n\n"
                          "📖 جب زندگی شروع ہوگی\n"
                          "✍️ ابو یحییٰ\n\n"
                          "اسلامی، فکری اور روحانی کتاب\n\n"
                          "Download now from Play Store 👇\n"
                          "https://play.google.com/store/apps/details?id=com.jabzindagishuruhogi.inzaar",
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// 🔹 FOOTER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  children: [
                    Text(
                      "جب زندگی شروع ہوگی",
                      style: TextStyle(
                        fontFamily: 'Urdu',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.text.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Version 1.0.3",
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.text.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 PRIVATE HEADER
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      alignment: Alignment.center,
      child: const Text(
        "جب زندگی شروع ہوگی",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Urdu',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
