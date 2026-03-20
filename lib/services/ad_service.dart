import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/iap_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final _iapService = IAPService();

  Future<bool> _isPremium() async {
    return await _iapService.getPremiumStatus();
  }

  // --- Ad Unit IDs ---

  // Real IDs
  static const String _realBannerUnitId = 'ca-app-pub-1803767801854733/8763065304';
  static const String _realInterstitialUnitId = 'ca-app-pub-1803767801854733/2948450084';
  static const String _realRewardedUnitId = 'ca-app-pub-1803767801854733/3734793770';
  static const String _realAppOpenUnitId = 'ca-app-pub-1803767801854733/9257395915'; // Placeholder, replace with real ID if provided

  // Test IDs (Google Official)
  static const String _testBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testAppOpenUnitId = 'ca-app-pub-3940256099942544/9257395915';

  // Select ID based on build mode
  String get _bannerUnitId => kDebugMode ? _testBannerUnitId : _realBannerUnitId;
  String get _interstitialUnitId => kDebugMode ? _testInterstitialUnitId : _realInterstitialUnitId;
  String get _rewardedUnitId => kDebugMode ? _testRewardedUnitId : _realRewardedUnitId;
  String get _appOpenUnitId => kDebugMode ? _testAppOpenUnitId : _realAppOpenUnitId;

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdLoading = false;
  DateTime? _appOpenLoadTime;

  /// Initialize and load the interstitial ad
  Future<void> loadInterstitialAd() async {
    if (await _isPremium()) return;
    
    await InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          _interstitialAd = null;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 10), () => loadInterstitialAd());
        },
      ),
    );
  }

  /// Show interstitial ad and return when ad is closed
  /// Returns true if ad was shown or skipped (premium)
  Future<bool> showInterstitialAd() async {
    if (await _isPremium()) return true;

    if (_interstitialAd == null || !_isAdLoaded) {
      // Try to load a new ad if none available
      await loadInterstitialAd();
      // Wait up to 2 seconds for it to load
      int retries = 0;
      while ((_interstitialAd == null || !_isAdLoaded) && retries < 4) {
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }
      
      if (_interstitialAd == null || !_isAdLoaded) {
        return false;
      }
    }

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        _isAdLoaded = false;
        loadInterstitialAd(); // Load next ad immediately
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        _isAdLoaded = false;
        loadInterstitialAd();
        completer.complete(false);
      },
    );

    await _interstitialAd!.show();
    return completer.future;
  }

  /// Show an ad for reward-gated flows.
  Future<bool> showRewardedUnlockAd() async {
    if (await _isPremium()) return true;

    if (_rewardedAd == null || !_isRewardedLoaded) {
      await loadRewardedAd();
      int retries = 0;
      while ((_rewardedAd == null || !_isRewardedLoaded) && retries < 4) {
        await Future.delayed(const Duration(milliseconds: 500));
        retries++;
      }
      
      if (_rewardedAd == null || !_isRewardedLoaded) {
        return false;
      }
    }

    final completer = Completer<bool>();
    var rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedLoaded = false;
        loadRewardedAd(); // Load next ad immediately
        completer.complete(rewardEarned);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedLoaded = false;
        loadRewardedAd();
        completer.complete(false);
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        rewardEarned = true;
      },
    );

    return completer.future;
  }

  Future<void> loadRewardedAd() async {
    if (await _isPremium()) return;

    await RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _isRewardedLoaded = false;
          // Retry loading
          Future.delayed(const Duration(seconds: 10), () => loadRewardedAd());
        },
      ),
    );
  }

  /// Load App Open Ad
  Future<void> loadAppOpenAd() async {
    if (await _isPremium() || _isAppOpenAdLoading) return;

    _isAppOpenAdLoading = true;
    AppOpenAd.load(
      adUnitId: _appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          _isAppOpenAdLoading = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Show App Open Ad
  Future<void> showAppOpenAd() async {
    if (await _isPremium()) return;

    if (_appOpenAd == null) {
      loadAppOpenAd();
      return;
    }

    // Checking if the ad has expired (4 hours is default limit for AppOpenAds)
    if (_appOpenLoadTime != null &&
        DateTime.now().difference(_appOpenLoadTime!).inHours >= 4) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    await _appOpenAd!.show();
  }

  /// Creates and returns a ready-to-use BannerAd
  BannerAd createBannerAd({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// Preload ads for faster display
  void preloadAd() async {
    if (await _isPremium()) return;

    if (!_isAdLoaded || _interstitialAd == null) {
      loadInterstitialAd();
    }
    if (!_isRewardedLoaded || _rewardedAd == null) {
      loadRewardedAd();
    }
    loadAppOpenAd();
  }
}
