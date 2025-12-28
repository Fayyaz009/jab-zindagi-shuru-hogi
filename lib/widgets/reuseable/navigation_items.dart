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

    // ================= DARK THEME =================
    const Color darkActive = Color(0xFFC9A24D); // muted gold
    const Color darkInactive = Color(0xFFB0B3C7); // soft grey-blue

    // ================= LIGHT THEME =================
    const Color lightActive = Color(0xFF222222); // near black
    const Color lightInactive = Color(0xFF9E9E9E); // soft grey

    // ================= SEPIA THEME =================
    const Color sepiaActive = Color(0xFF8B6B4F); // brown-gold
    const Color sepiaInactive = Color(0xFFB8A58A); // faded paper brown

    // ================= FINAL COLOR =================
    final Color itemColor = themeType == AppThemeType.dark
        ? (isSelected ? darkActive : darkInactive)
        : themeType == AppThemeType.sepia
        ? (isSelected ? sepiaActive : sepiaInactive)
        : (isSelected ? lightActive : lightInactive);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26, color: itemColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: itemColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
