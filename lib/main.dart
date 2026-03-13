import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/change_navigation_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/font_size/bloc/font_size_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/notes_bloc/notes_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/premium_bloc/premium_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/progress_bloc/bloc/progress_bar_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/connectivity_bloc/connectivity_bloc.dart';

import 'package:jab_zindagi_shuru_hogi_inzaar/screens/home_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/no_internet_screen.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/screens/splash_screen.dart'; // Added this import

import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_event.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/bloc/bloc/theme_state.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/iap_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/connectivity_service.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/themes/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  AdService().preloadAd();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final adService = AdService();
    final iapService = IAPService();
    final connectivityService = ConnectivityService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: adService),
        RepositoryProvider.value(value: iapService),
        RepositoryProvider.value(value: connectivityService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ChangeNavigationBloc()),
          BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
          BlocProvider(create: (_) => FontSizeBloc()..add(LoadFontSize())),
          BlocProvider(create: (_) => ProgressBarBloc()..add(LoadProgress())),
          BlocProvider(create: (_) => NotesBloc()..add(LoadNotes())),
          BlocProvider(create: (_) => PremiumBloc()),
          BlocProvider(create: (_) => ConnectivityBloc(connectivityService)),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<FontSizeBloc, FontSizeState>(
          builder: (context, fontState) {
            return BlocBuilder<ProgressBarBloc, ProgressBarState>(
              builder: (context, progressState) {
                if (themeState is ThemeLoading ||
                    fontState is FontSizeLoading ||
                    progressState is ProgressBarLoading) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Scaffold(body: Center(child: CircularProgressIndicator())),
                  );
                }

                final double textScale = fontState.scale;

                return BlocListener<PremiumBloc, PremiumState>(
                  listener: (context, premiumState) {
                    context
                        .read<ThemeBloc>()
                        .add(SyncPremiumStatus(premiumState.isPremium));
                  },
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: AppThemes.getTheme(themeState.themeType),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(textScale),
                        ),
                        child: child!,
                      );
                    },
                    home: const SplashScreen(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, premiumState) {
        return BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            // Premium users can work offline. Free users need internet.
            if (!premiumState.isPremium &&
                connectivityState.status == ConnectivityStatus.offline) {
              return const NoInternetScreen();
            }
            return const HomeScreen();
          },
        );
      },
    );
  }
}
