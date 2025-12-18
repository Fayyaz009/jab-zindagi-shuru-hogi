import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/bookmarks.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_data.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/chapter_item.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/hero_section.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_background.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_header.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/library.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/profile.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/reading_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/start_reading_button.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/app_drawer.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/widgets/reuseable/navigation_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeType themeType = context.watch<ThemeBloc>().state.themeType;

    return BlocBuilder<ChangeNavigationBloc, ChangeNavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          drawer: AppDrawer(themeType: themeType),
          backgroundColor: themeType == AppThemeType.dark
              ? const Color(0xFF090A15)
              : themeType == AppThemeType.sepia
              ? const Color(0xFFF4E8C1)
              : Colors.white,

          body: Stack(
            children: [
              /// BACKGROUND (only once)
              HomeBackground(themeType: themeType),

              /// CONTENT (NO REBUILD LAG)
              IndexedStack(
                index: state.index,
                children: [
                  /// HOME
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          HomeHeader(themeType: themeType),
                          const SizedBox(height: 30),
                          HeroSection(themeType: themeType),
                          const SizedBox(height: 40),
                          StartReadingButton(themeType: themeType),
                          const SizedBox(height: 40),

                          ...chapterItems.map(
                            (chapter) => ChapterItem(
                              title: chapter["title"],
                              icon: chapter["icon"],
                              progress: chapter["progress"],
                              themeType: themeType,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReadingScreen(
                                      chapterTitle: chapter["title"],
                                      themeType: themeType,
                                      readingText: chapter["readingText"],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),

                  /// LIBRARY
                  Library(themeType: themeType, title: 'Library'),

                  /// BOOKMARKS
                  Bookmarks(themeType: themeType, title: 'Bookmarks'),

                  /// PROFILE
                  Profile(title: "Profile", themeType: themeType),
                ],
              ),
            ],
          ),

          /// BOTTOM NAV
          bottomNavigationBar:
              BlocBuilder<ChangeNavigationBloc, ChangeNavigationState>(
                builder: (context, state) {
                  return CurvedNavigationBar(
                    index: state.index,
                    backgroundColor: Colors.transparent,
                    buttonBackgroundColor: Colors.transparent,
                    color: themeType == AppThemeType.dark
                        ? const Color(0xFF2D176D)
                        : themeType == AppThemeType.sepia
                        ? const Color(0xFF8B6B4A)
                        : const Color(0xFFE0E0E0),
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
                        label: 'Bookmarks',
                        icon: Icons.bookmark,
                        index: 2,
                        selectedIndex: state.index,
                      ),
                      NavigationItems(
                        label: 'Profile',
                        icon: Icons.person,
                        index: 3,
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
