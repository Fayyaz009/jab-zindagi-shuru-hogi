import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class NavigationItems extends StatelessWidget {
  final String label;
  final IconData icon;
  final int selectedIndex;
  final int index;

  const NavigationItems({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;
    final AppThemeType themeType = context.watch<ThemeBloc>().state.themeType;

    // ================= DARK THEME (as-is, GOLD highlight) =================
    const Color darkActive = Color(0xFFFFD700); // GOLD
    const Color darkInactive = Colors.white70;

    // ================= LIGHT THEME =================
    const Color lightActive = Colors.black;
    final Color lightInactive = Colors.black.withValues(alpha: 0.6);

    // ================= SEPIA THEME =================
    const Color sepiaActive = Color(0xFF6D4C41); // brown
    final Color sepiaInactive = const Color.fromARGB(
      255,
      0,
      0,
      0,
    ).withValues(alpha: 0.6);

    // ================= ICON COLOR =================
    final Color iconColor = themeType == AppThemeType.dark
        ? (isSelected ? darkActive : darkInactive)
        : themeType == AppThemeType.sepia
        ? (isSelected ? sepiaActive : sepiaInactive)
        : (isSelected ? lightActive : lightInactive);

    // ================= TEXT COLOR =================
    final Color textColor = iconColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26, color: iconColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
