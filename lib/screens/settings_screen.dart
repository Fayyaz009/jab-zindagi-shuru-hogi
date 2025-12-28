import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/font_size/bloc/font_size_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final AppThemeType currentTheme = context
        .watch<ThemeBloc>()
        .state
        .themeType;

    // 📐 Responsive values
    final double horizontalPadding = width * 0.05;
    final double verticalPadding = height * 0.025;
    final double sectionSpacing = height * 0.035;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(themeType: currentTheme),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: Text("Settings", style: textTheme.titleLarge),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          children: [
            // ================= THEME SECTION =================
            _SectionCard(
              title: "Theme",
              maxWidth: width > 600 ? 520 : double.infinity,
              child: RadioGroup<AppThemeType>(
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeTheme(value));
                  }
                },
                child: Column(
                  children: const [
                    RadioListTile<AppThemeType>(
                      value: AppThemeType.light,
                      title: Text("Light"),
                    ),
                    RadioListTile<AppThemeType>(
                      value: AppThemeType.sepia,
                      title: Text("Sepia"),
                    ),
                    RadioListTile<AppThemeType>(
                      value: AppThemeType.dark,
                      title: Text("Dark"),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: sectionSpacing),

            // ================= FONT SIZE SECTION =================
            _SectionCard(
              title: "Font Size",
              maxWidth: width > 600 ? 520 : double.infinity,
              child: BlocBuilder<FontSizeBloc, FontSizeState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Slider(
                        value: state.scale,
                        min: 1.0,
                        max: 1.5,
                        onChanged: (value) {
                          context.read<FontSizeBloc>().add(
                            ChangeFontSize(value),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.015),
                      Text(
                        "جب زندگی شروع ہوگی",
                        textDirection: TextDirection.rtl,
                        style: textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Urdu',
                          fontSize: (18 * state.scale).clamp(16, 28),
                          height: 1.7,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= REUSABLE SECTION CARD =================
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double maxWidth;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
