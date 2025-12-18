import 'package:flutter/material.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/profile.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/settings_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class AppDrawer extends StatelessWidget {
  final AppThemeType themeType;

  const AppDrawer({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = themeType == AppThemeType.dark
        ? const Color(0xFF0E0E2C)
        : themeType == AppThemeType.sepia
        ? const Color(0xFFF4E8C1)
        : Colors.white;

    final Color textColor = themeType == AppThemeType.dark
        ? Colors.white
        : themeType == AppThemeType.sepia
        ? const Color(0xFF4E342E)
        : Colors.black;

    final Color iconColor = themeType == AppThemeType.dark
        ? const Color(0xFFFFD700)
        : themeType == AppThemeType.sepia
        ? const Color(0xFF6D4C41)
        : Colors.black54;

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          /// HEADER
          DrawerHeader(
            padding: EdgeInsetsGeometry.all(45),

            decoration: BoxDecoration(
              border: Border.all(
                color: themeType == AppThemeType.dark
                    ? const Color(0xFF1B1B3A)
                    : themeType == AppThemeType.sepia
                    ? Color(0xFFE6D3A3)
                    : Colors.white,
              ),
              color: themeType == AppThemeType.dark
                  ? const Color(0xFF1B1B3A)
                  : themeType == AppThemeType.sepia
                  ? Color(0xFFE6D3A3)
                  : Colors.white,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "جب زندگی شروع ہوگی",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urdu',
                    fontSize: 22,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),

          /// PROFILE
          _drawerItem(
            icon: Icons.person,
            title: "Profile",
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      Profile(themeType: themeType, title: 'Profile'),
                ),
              );
            },
          ),

          /// SETTINGS
          _drawerItem(
            icon: Icons.settings,
            title: "Settings",
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(themeType: themeType),
                ),
              );
            },
          ),

          /// ABOUT
          _drawerItem(
            icon: Icons.info_outline,
            title: "About",
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {},
          ),

          /// DONATE
          _drawerItem(
            icon: Icons.volunteer_activism,
            title: "Donate",
            iconColor: iconColor,
            textColor: textColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
