import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_item.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/hero_section.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_background.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_header.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/library.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/settings_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/start_reading_button.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/navigation_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppThemeType themeType = context.watch<ThemeBloc>().state.themeType;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocBuilder<ChangeNavigationBloc, ChangeNavigationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: AppDrawer(themeType: themeType),
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: colorScheme.onSurface),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),

            centerTitle: true,
            title: Text(
              "جب زندگی شروع ہوگی",
              style: textTheme.titleLarge?.copyWith(fontFamily: 'Urdu'),
            ),
            actions: [
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
          ),

          // ================= BODY =================
          body: Stack(
            children: [
              HomeBackground(themeType: themeType),

              IndexedStack(
                index: state.index,
                children: [
                  // ================= HOME TAB =================
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, // responsive padding
                        vertical: height * 0.02,
                      ),
                      child: Column(
                        children: [
                          // HomeHeader(themeType: themeType),
                          SizedBox(height: height * 0.04),

                          HeroSection(themeType: themeType),

                          SizedBox(height: height * 0.05),

                          StartReadingButton(themeType: themeType),

                          SizedBox(height: height * 0.05),

                          // ========== PROGRESS + CHAPTERS ==========
                          BlocBuilder<ProgressBarBloc, ProgressBarState>(
                            builder: (context, progressState) {
                              final Map<int, double> progressMap = {};

                              if (progressState is ProgressBarLoaded) {
                                for (var model
                                    in progressState.chapterProgress) {
                                  progressMap[model.chapterID] = model.progress;
                                }
                              }

                              return Column(
                                children: chapterItems.map((chapter) {
                                  final int chapterId =
                                      chapter['chapterID'] as int;
                                  final double currentProgress =
                                      progressMap[chapterId] ?? 0.0;

                                  return ChapterItem(
                                    title: chapter["title"] as String,
                                    icon: chapter["icon"] as IconData,
                                    progress: currentProgress,
                                    themeType: themeType,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ReadingScreen(
                                            chapterTitle:
                                                chapter["title"] as String,
                                            readingText:
                                                chapter["readingText"]
                                                    as String? ??
                                                '',
                                            chapterID: chapterId,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),

                          /// 👇 Bottom nav ke liye safe spacing
                          SizedBox(height: height * 0.12),
                        ],
                      ),
                    ),
                  ),

                  // ================= LIBRARY TAB =================
                  const Library(title: 'Library'),

                  // ================= SETTINGS TAB =================
                  const SettingsScreen(),
                ],
              ),
            ],
          ),

          // ================= BOTTOM NAV =================
          bottomNavigationBar:
              BlocBuilder<ChangeNavigationBloc, ChangeNavigationState>(
                builder: (context, state) {
                  return CurvedNavigationBar(
                    index: state.index,
                    backgroundColor: Colors.transparent,
                    buttonBackgroundColor: Colors.transparent,
                    color: theme.cardColor,
                    height: height * 0.075, // responsive nav height

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
                        label: 'Settings',
                        icon: Icons.settings,
                        index: 2,
                        selectedIndex: state.index,
                      ),
                    ],

                    onTap: (i) {
                      context.read<ChangeNavigationBloc>().add(
                        ChangeNavigation(selectedIndex: i),
                      );
                    },
                  );
                },
              ),
        );
      },
    );
  }
}
