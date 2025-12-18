import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/font_size/bloc/font_size_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  final AppThemeType themeType;
  const SettingsScreen({super.key, required this.themeType});

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
        centerTitle: true,
        title: const Text("Settings"),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Font Size",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<FontSizeBloc, FontSizeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Slider(
                      value: state.scale,
                      min: 1.0,
                      max: 1.8,

                      label: state.scale.toStringAsFixed(1),
                      onChanged: (value) {
                        context.read<FontSizeBloc>().add(ChangeFontSize(value));
                      },
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "جب زندگی شروع ہوگی",
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                        fontFamily: 'Urdu',
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
