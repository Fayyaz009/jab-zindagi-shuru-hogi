import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class HomeHeader extends StatelessWidget {
  final AppThemeType themeType;

  const HomeHeader({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ================= DRAWER BUTTON =================
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, color: colorScheme.onSurface),
        ),

        // ================= TITLE =================
        Text(
          "جب زندگی شروع ہوگی",
          style: textTheme.titleLarge?.copyWith(fontFamily: 'Urdu'),
        ),

        // ================= THEME TOGGLE =================
        IconButton(
          icon: Icon(
            themeType == AppThemeType.dark
                ? Icons.dark_mode
                : themeType == AppThemeType.light
                ? Icons.light_mode
                : Icons.auto_stories,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            final nextTheme = themeType == AppThemeType.dark
                ? AppThemeType.light
                : themeType == AppThemeType.light
                ? AppThemeType.sepia
                : AppThemeType.dark;

            context.read<ThemeBloc>().add(ChangeTheme(nextTheme));
          },
        ),
      ],
    );
  }
}
