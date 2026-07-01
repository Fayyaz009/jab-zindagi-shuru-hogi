import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/iap_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();
  
  Completer<void>? _initCompleter;

  /// Initialize the Google Mobile Ads SDK.
  Future<void> init() async {
    if (_initCompleter != null) return _initCompleter!.future;
    
    _initCompleter = Completer<void>();
    debugPrint('AdService: Initializing MobileAds SDK...');
    try {
      await MobileAds.instance.initialize();
      debugPrint('AdService: MobileAds SDK Initialized');
      _initCompleter!.complete();
    } catch (e) {
      debugPrint('AdService: Initialization error: $e');
      _initCompleter!.completeError(e);
      _initCompleter = null; // Allow retry if failed
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initCompleter == null) {
      await init();
    }
    return _initCompleter!.future;
  }

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
  int _interstitialRetryAttempt = 0;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;
  int _rewardedRetryAttempt = 0;

  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdLoading = false;
  DateTime? _appOpenLoadTime;
  int _appOpenRetryAttempt = 0;

  /// Helper to get adaptive banner size
  Future<AdSize> getAdaptiveBannerSize(BuildContext context) async {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width.truncate();
    
    return await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(orientation, width) ?? AdSize.banner;
  }

  /// Initialize and load the interstitial ad
  Future<void> loadInterstitialAd() async {
    await _ensureInitialized();
    if (await _isPremium() || _isAdLoaded) return;
    
    debugPrint('AdService: Loading Interstitial Ad (Attempt: $_interstitialRetryAttempt)');
    
    await InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('AdService: Interstitial Ad Loaded');
          _interstitialAd = ad;
          _isAdLoaded = true;
          _interstitialRetryAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdService: Interstitial Ad Failed to Load: $error');
          _isAdLoaded = false;
          _interstitialAd = null;
          
          _interstitialRetryAttempt++;
          // Exponential backoff: 5s, 10s, 20s, 40s, max 60s
          int delay = (5 * (1 << (_interstitialRetryAttempt - 1))).clamp(5, 60);
          Future.delayed(Duration(seconds: delay), () => loadInterstitialAd());
        },
      ),
    );
  }

  /// Show interstitial ad and return when ad is closed
  /// Returns true if ad was shown or skipped (premium)
  Future<bool> showInterstitialAd() async {
    if (await _isPremium()) return true;

    if (_interstitialAd == null || !_isAdLoaded) {
      debugPrint('AdService: Interstitial requested but not ready. Loading for next time.');
      loadInterstitialAd();
      return false;
    }

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => debugPrint('AdService: Interstitial Ad Shown'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('AdService: Interstitial Ad Dismissed');
        ad.dispose();
        _interstitialAd = null;
        _isAdLoaded = false;
        loadInterstitialAd(); // Load next ad immediately
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('AdService: Interstitial Ad Failed to Show: $error');
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
    await _ensureInitialized();
    if (await _isPremium() || _isRewardedLoaded) return;

    debugPrint('AdService: Loading Rewarded Ad (Attempt: $_rewardedRetryAttempt)');

    await RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('AdService: Rewarded Ad Loaded');
          _rewardedAd = ad;
          _isRewardedLoaded = true;
          _rewardedRetryAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdService: Rewarded Ad Failed to Load: $error');
          _rewardedAd = null;
          _isRewardedLoaded = false;
          
          _rewardedRetryAttempt++;
          int delay = (5 * (1 << (_rewardedRetryAttempt - 1))).clamp(5, 60);
          Future.delayed(Duration(seconds: delay), () => loadRewardedAd());
        },
      ),
    );
  }

  /// Load App Open Ad
  Future<void> loadAppOpenAd() async {
    await _ensureInitialized();
    if (await _isPremium() || _isAppOpenAdLoading) return;

    debugPrint('AdService: Loading App Open Ad (Attempt: $_appOpenRetryAttempt)');

    _isAppOpenAdLoading = true;
    AppOpenAd.load(
      adUnitId: _appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: App Open Ad Loaded');
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
          _appOpenLoadTime = DateTime.now();
          _appOpenRetryAttempt = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: App Open Ad Failed to Load: $error');
          _isAppOpenAdLoading = false;
          _appOpenAd = null;
          
          _appOpenRetryAttempt++;
          int delay = (5 * (1 << (_appOpenRetryAttempt - 1))).clamp(5, 60);
          Future.delayed(Duration(seconds: delay), () => loadAppOpenAd());
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
    required AdSize size,
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    debugPrint('AdService: Creating Banner Ad ($size)');
    return BannerAd(
      adUnitId: _bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdService: Banner Ad Loaded');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: Banner Ad Failed to Load: $error');
          onAdFailedToLoad(ad, error);
        },
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
