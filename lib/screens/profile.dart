import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class Profile extends StatelessWidget {
  final AppThemeType themeType;
  final String title;
  const Profile({super.key, required this.themeType, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeType = context.watch<ThemeBloc>().state.themeType;

    final Color textColor = themeType == AppThemeType.dark
        ? Colors.white
        : themeType == AppThemeType.sepia
        ? const Color(0xFF4E342E)
        : Colors.black87;
    final Color bgColor = themeType == AppThemeType.dark
        ? const Color(0xFF0E0E2C)
        : themeType == AppThemeType.sepia
        ? const Color(0xFFF4E8C1)
        : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu, color: textColor),
        ),
        centerTitle: true,
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                themeType == AppThemeType.dark
                    ? Icons.dark_mode
                    : themeType == AppThemeType.light
                    ? Icons.light_mode
                    : Icons.auto_stories,
                color: textColor,
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
          ),
        ],
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(title, style: TextStyle(color: textColor)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
