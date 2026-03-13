import 'dart:async';

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

  // Unit ID provided by user
  static const String _interstitialUnitId =
      'ca-app-pub-1803767801854733/2948450084';
  static const String _rewardedUnitId =
      'ca-app-pub-1803767801854733/3734793770';

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;

  /// Initialize and load the interstitial ad
  Future<void> loadInterstitialAd() async {
    if (await _isPremium()) return;
    
    await InterstitialAd.load(
// ... rest of the file ...
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
        },
      ),
    );
  }

  /// Show interstitial ad and return when ad is closed
  /// Returns true if ad was shown, false otherwise
  Future<bool> showInterstitialAd() async {
    if (await _isPremium()) return true;

    if (_interstitialAd == null || !_isAdLoaded) {
      // Try to load a new ad if none available
      await loadInterstitialAd();
      if (_interstitialAd == null || !_isAdLoaded) {
        return false;
      }
    }

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // Ad dismissed, load next ad for future use
        _interstitialAd = null;
        _isAdLoaded = false;
        loadInterstitialAd();
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
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
  /// Returns true only when user earns reward.
  Future<bool> showRewardedUnlockAd() async {
    if (await _isPremium()) return true;

    if (_rewardedAd == null || !_isRewardedLoaded) {
      await loadRewardedAd();
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
        loadRewardedAd();
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
        },
      ),
    );
  }

  /// Preload ad for faster display
  void preloadAd() async {
    if (await _isPremium()) return;

    if (!_isAdLoaded || _interstitialAd == null) {
      loadInterstitialAd();
    }
    if (!_isRewardedLoaded || _rewardedAd == null) {
      loadRewardedAd();
    }
  }
}
