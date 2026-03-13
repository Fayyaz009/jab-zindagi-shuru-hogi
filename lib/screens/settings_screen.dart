import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/font_size/bloc/font_size_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/premium_bloc/premium_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/premium_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<PremiumBloc, PremiumState>(
        builder: (context, premiumState) {
          final currentTheme = context.watch<ThemeBloc>().state.themeType;
          final isSepiaUnlocked = context.read<ThemeBloc>().isSepiaUnlocked;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              const SizedBox(height: 32),
              const SizedBox(height: 12),

              _buildPremiumCard(context, premiumState),

              const SizedBox(height: 32),
              _buildSectionHeader(
                context,
                'Appearance',
                Icons.palette_outlined,
              ),
              const SizedBox(height: 12),
              MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 180),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildThemeTile(
                          context,
                          'Light Mode',
                          Icons.wb_sunny_outlined,
                          AppThemeType.light,
                          currentTheme == AppThemeType.light,
                          true,
                        ),
                        _buildDivider(colorScheme),
                        _buildThemeTile(
                          context,
                          'Dark Mode',
                          Icons.dark_mode_outlined,
                          AppThemeType.dark,
                          currentTheme == AppThemeType.dark,
                          true,
                        ),
                        _buildDivider(colorScheme),
                        _buildThemeTile(
                          context,
                          'Sepia Mode',
                          Icons.menu_book_outlined,
                          AppThemeType.sepia,
                          currentTheme == AppThemeType.sepia,
                          isSepiaUnlocked,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(
                context,
                'Reading Preferences',
                Icons.text_fields_outlined,
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 180),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.noScaling),
                          child: Row(
                            children: [
                              Icon(
                                Icons.format_size,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Text Zoom',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              BlocBuilder<FontSizeBloc, FontSizeState>(
                                builder: (context, state) {
                                  return Text(
                                    '${(state.scale * 100).toInt()}%',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<FontSizeBloc, FontSizeState>(
                          builder: (context, state) {
                            return Slider(
                              value: state.scale,
                              min: 1.0,
                              max: 1.5,
                              activeColor: colorScheme.primary,
                              inactiveColor: colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              onChanged: (value) {
                                context.read<FontSizeBloc>().add(
                                  ChangeFontSize(value),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: BlocBuilder<FontSizeBloc, FontSizeState>(
                            builder: (context, state) {
                              return Text(
                                'یہ ایک نمونہ عبارت ہے۔',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Urdu',
                                  fontSize: 18 * state.scale,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Text(
                  'Jab Zindagi Shuru Hogi',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    String title,
    IconData icon,
    AppThemeType type,
    bool isSelected,
    bool isUnlocked,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: !isUnlocked
          ? Icon(Icons.lock_outline, size: 18, color: colorScheme.error)
          : (isSelected
                ? Icon(Icons.check_circle, color: colorScheme.primary)
                : null),
      onTap: () => _handleThemeSelection(context, type, isUnlocked),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 20,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Future<void> _handleThemeSelection(
    BuildContext context,
    AppThemeType value,
    bool isUnlocked,
  ) async {
    if (!isUnlocked) {
      final shouldUnlock = await _showSepiaUnlockDialog(context);
      if (!shouldUnlock || !context.mounted) return;

      final bool adCompleted = await AdService().showRewardedUnlockAd();
      if (context.mounted && adCompleted) {
        context.read<ThemeBloc>().add(UnlockSepia());
        context.read<ThemeBloc>().add(ChangeTheme(value));
      }
      return;
    }
    context.read<ThemeBloc>().add(ChangeTheme(value));
  }

  Future<bool> _showSepiaUnlockDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Unlock Sepia Theme'),
            content: const Text(
              'Would you like to watch a short ad to unlock the premium Sepia reading experience?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Maybe Later'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Watch Ad'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

Widget _buildPremiumCard(BuildContext context, dynamic premiumState) {
  final bool isPremium = premiumState.isPremium;

  // Refined Color Palettes
  final List<Color> gradientColors = isPremium
      ? [
          const Color(0xFF0D3210),
          const Color(0xFF1B5E20),
          const Color(0xFF388E3C),
        ] // Emerald Mesh
      : [
          const Color(0xFF7A5C2A),
          const Color(0xFFB0893F),
          const Color(0xFFE5C17B),
        ]; // Champagne Gold

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: gradientColors[1].withValues(alpha: 0.25),
          blurRadius: 25,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PremiumScreen()),
          ),
          child: Stack(
            children: [
              // 1. Base Mesh Gradient Background
              Container(
                height: 110, // Fixed height for a sleek horizontal profile
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [gradientColors[0], gradientColors[1]],
                  ),
                ),
              ),

              // 2. Decorative "Light Orb" (The Glow)
              Positioned(
                right: -20,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        gradientColors[2].withValues(alpha: 0.4),
                        gradientColors[2].withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Inner Glass Border Effect
              Container(
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildPremiumIconBadge(isPremium, gradientColors[2]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isPremium
                                  ? 'Premium Active'
                                  : 'Upgrade To Premium',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isPremium
                                  ? 'Unlimited Access Enabled'
                                  : 'Support The Mission & Go Ad-Free',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPremiumIconBadge(bool isPremium, Color highlightColor) {
  return Container(
    height: 54,
    width: 54,
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.1),
      shape: BoxShape.circle,
      border: Border.all(
        color: highlightColor.withValues(alpha: 0.5),
        width: 2,
      ),
    ),
    child: Center(
      child: Icon(
        isPremium ? Icons.verified_rounded : Icons.workspace_premium_rounded,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}
