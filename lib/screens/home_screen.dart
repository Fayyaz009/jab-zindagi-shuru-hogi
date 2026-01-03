import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/library.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/settings_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/navigation_items.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_item.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/hero_section.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_background.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_header.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/start_reading_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          body: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              context.read<ChangeNavigationBloc>().add(
                ChangeNavigation(selectedIndex: index),
              );
            },
            children: const [
              _HomeTab(),
              Library(title: 'Library'),
              SettingsScreen(),
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
                label: 'Settings',
                icon: Icons.settings,
                index: 2,
                selectedIndex: state.index,
              ),
            ],
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
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
                SizedBox(height: size.height * 0.04),
                HeroSection(themeType: themeType),
                SizedBox(height: size.height * 0.05),
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
                      children: chapterItems.map((chapter) {
                        final int chapterId = chapter['chapterID'] as int;

                        return ChapterItem(
                          title: chapter["title"],
                          icon: chapter["icon"],
                          progress: progressMap[chapterId] ?? 0.0,
                          themeType: themeType,
                          onTap: () {
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
                          },
                        );
                      }).toList(),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
