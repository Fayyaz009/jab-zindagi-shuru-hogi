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
    final color = themeType == AppThemeType.dark
        ? Colors.white
        : themeType == AppThemeType.sepia
        ? const Color(0xFF4E342E)
        : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, color: color),
        ),

        Text(
          "جب زندگی شروع ہوگی",
          style: TextStyle(fontFamily: 'Urdu', fontSize: 24, color: color),
        ),

        IconButton(
          icon: Icon(
            themeType == AppThemeType.dark
                ? Icons.dark_mode
                : themeType == AppThemeType.light
                ? Icons.light_mode
                : Icons.auto_stories,
            color: color,
          ),
          onPressed: () {
            final next = themeType == AppThemeType.dark
                ? AppThemeType.light
                : themeType == AppThemeType.light
                ? AppThemeType.sepia
                : AppThemeType.dark;

            context.read<ThemeBloc>().add(ChangeTheme(next));
          },
        ),
      ],
    );
  }
}
