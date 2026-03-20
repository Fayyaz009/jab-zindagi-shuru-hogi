import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/library.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/notes_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/settings_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/banner_ad_widget.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/navigation_items.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/premium_bloc/premium_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/premium_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_item.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/hero_section.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_background.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_header.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/start_reading_button.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeType = context.watch<ThemeBloc>().state.themeType;

    final size = MediaQuery.of(context).size;
    final height = size.height;

    return BlocBuilder<ChangeNavigationBloc, ChangeNavigationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: AppDrawer(themeType: themeType),
          backgroundColor: theme.scaffoldBackgroundColor,

          // ================= BODY =================
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: state.index,
                  children: const [
                    _HomeTab(),
                    Library(title: 'Library'),
                    NotesScreen(),
                    SettingsScreen(),
                  ],
                ),
              ),
              const BannerAdWidget(),
            ],
          ),

          // ================= BOTTOM NAV =================
          bottomNavigationBar: CurvedNavigationBar(
            index: state.index,
            height: height * 0.075,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Colors.transparent,
            color: theme.cardColor,
            items: [
              NavigationItems(
                label: 'Home',
                icon: Icons.home,
                index: 0,
                selectedIndex: state.index,
              ),
              NavigationItems(
                label: 'Library',
                icon: Icons.library_books,
                index: 1,
                selectedIndex: state.index,
              ),
              NavigationItems(
                label: 'My Notes',
                icon: Icons.note_alt_outlined,
                index: 2,
                selectedIndex: state.index,
              ),
              NavigationItems(
                label: 'Settings',
                icon: Icons.settings,
                index: 3,
                selectedIndex: state.index,
              ),
            ],
            onTap: (index) {
              context.read<ChangeNavigationBloc>().add(
                ChangeNavigation(selectedIndex: index),
              );
            },
          ),
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final themeType = context.watch<ThemeBloc>().state.themeType;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        HomeBackground(themeType: themeType),

        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                HomeHeader(themeType: themeType),
                SizedBox(height: size.height * 0.02),

                // ================= PREMIUM BANNER =================
                BlocBuilder<PremiumBloc, PremiumState>(
                  builder: (context, state) {
                    if (state.isPremium) return const SizedBox.shrink();

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFB0893F,
                            ).withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PremiumScreen(),
                              ),
                            ),
                            child: Stack(
                              children: [
                                // 1. Rich Gradient Background
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      // Sophisticated Golden Glow
                                      BoxShadow(
                                        color: const Color(
                                          0xFFD4AF37,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 25,
                                        spreadRadius: -5,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Stack(
                                      children: [
                                        // 1. Multi-stop Metallic Gradient
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 22,
                                            vertical: 24,
                                          ),
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(
                                                  0xFFF9E498,
                                                ), // Bright Sunlight Gold
                                                Color(
                                                  0xFFD4AF37,
                                                ), // Classic Metallic Gold
                                                Color(
                                                  0xFFB0893F,
                                                ), // Deep Ochre (Reflection)
                                                Color(
                                                  0xFF856A37,
                                                ), // Burnished Bronze (Depth)
                                              ],
                                              stops: [
                                                0.0,
                                                0.3,
                                                0.7,
                                                1.0,
                                              ], // Controls the "shine"
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // 2. High-Contrast Icon Circle
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.4),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .workspace_premium_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                              const SizedBox(width: 16),

                                              // 3. Text Section
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: const Text(
                                                        'REMOVE ALL ADS',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 18,
                                                          letterSpacing: 1.2,
                                                          shadows: [
                                                            Shadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 4,
                                                              offset: Offset(
                                                                0,
                                                                2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              // 4. Glass-effect Arrow
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 5. White "Shimmer" Overlay (The secret for a metallic look)
                                        Positioned(
                                          top: -50,
                                          left: -20,
                                          child: Transform.rotate(
                                            angle: 0.5,
                                            child: Container(
                                              width: 40,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white.withValues(
                                                      alpha: 0.0,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.2,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 5. Decorative Light Streak (The "Polish" look)
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.03,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.03),
                HeroSection(themeType: themeType),
                SizedBox(height: size.height * 0.04),
                StartReadingButton(themeType: themeType),
                SizedBox(height: size.height * 0.05),

                BlocBuilder<ProgressBarBloc, ProgressBarState>(
                  builder: (context, progressState) {
                    final Map<int, double> progressMap = {};

                    if (progressState is ProgressBarLoaded) {
                      for (var model in progressState.chapterProgress) {
                        progressMap[model.chapterID] = model.progress;
                      }
                    }

                    return Column(
                      children: chapterItems.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Map<String, dynamic> chapter = entry.value;
                        final int chapterId = chapter['chapterID'] as int;

                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOutCubic,
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: ChapterItem(
                            title: chapter["title"],
                            icon: chapter["icon"],
                            progress: progressMap[chapterId] ?? 0.0,
                            themeType: themeType,
                            onTap: () async {
                              // Show interstitial ad before navigating
                              await AdService().showInterstitialAd();
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReadingScreen(
                                      chapterTitle: chapter["title"],
                                      readingText: chapter["readingText"] ?? '',
                                      chapterID: chapterId,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.05),
                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


