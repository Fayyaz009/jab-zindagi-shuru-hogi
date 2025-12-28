import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/font_size/bloc/font_size_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';

import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_screen.dart';

import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChangeNavigationBloc()),
        BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
        BlocProvider(create: (_) => FontSizeBloc()..add(LoadFontSize())),
        BlocProvider(create: (_) => ProgressBarBloc()..add(LoadProgress())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<FontSizeBloc, FontSizeState>(
            builder: (context, fontState) {
              return BlocBuilder<ProgressBarBloc, ProgressBarState>(
                builder: (context, progressState) {
                  /// ⏳ WAIT until everything is loaded
                  if (themeState is ThemeLoading ||
                      fontState is FontSizeLoading ||
                      progressState is ProgressBarLoading) {
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  /// ✅ SAFE DATA AFTER LOADING
                  final ThemeData baseTheme = themeState.themeData;
                  final double textScale = fontState.scale;

                  return MaterialApp(
                    debugShowCheckedModeBanner: false,

                    /// ✅ CORRECT Material 3 ENABLE (NO DEPRECATION)
                    theme: ThemeData.from(
                      colorScheme: baseTheme.colorScheme,
                      textTheme: baseTheme.textTheme,
                      useMaterial3: true,
                    ),

                    /// 🔤 GLOBAL FONT SCALE
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(textScaler: TextScaler.linear(textScale)),
                        child: child!,
                      );
                    },

                    home: const HomeScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
