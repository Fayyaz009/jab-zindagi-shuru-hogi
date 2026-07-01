import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../main.dart';
import '../features/update/data/update_repository.dart';
import '../features/update/domain/update_config.dart';
import '../features/update/utils/version_helper.dart';
import '../features/update/presentation/force_update_screen.dart';
import '../services/ad_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppUpdate();
  }

  Future<void> _checkAppUpdate() async {
    final startTime = DateTime.now();
    UpdateConfig? forceUpdateConfig;
    UpdateConfig? softUpdateConfig;

    try {
      // 1. Get current installed version info
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

      // 2. Initialize UMP Consent & Mobile Ads
      try {
        await AdService().init();
        AdService().preloadAd();
      } catch (e) {
        debugPrint('SplashScreen: AdService initialization error: $e');
      }

      // 3. Fetch remote update configurations
      final repo = UpdateRepository();
      final config = await repo.fetchUpdateConfig();

      if (config != null) {
        final isHardUpdate = VersionHelper.isVersionLower(currentVersion, config.minRequiredVersion) || 
                             config.forceUpdateOverride;
        final isSoftUpdate = VersionHelper.isVersionLower(currentVersion, config.latestVersion);

        if (isHardUpdate) {
          forceUpdateConfig = config;
        } else if (isSoftUpdate) {
          softUpdateConfig = config;
        }
      }
    } catch (_) {
      // Graceful degradation: If network fails or throws an exception, continue to the app normally
    }

    // Ensure splash screen remains active for at least 1.5 seconds for visual styling and initialization smoothness
    final elapsedTime = DateTime.now().difference(startTime);
    final remainingTime = const Duration(milliseconds: 1500) - elapsedTime;
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    if (!mounted) return;

    if (forceUpdateConfig != null) {
      // User must update (Hard block)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ForceUpdateScreen(config: forceUpdateConfig!),
        ),
      );
    } else {
      // User can proceed to app. Pass soft update info if any
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AppContent(softUpdateConfig: softUpdateConfig),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          SizedBox.expand(
            child: Image.asset('assets/images/splash.png', fit: BoxFit.cover),
          ),

          /// Loader at Bottom
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
