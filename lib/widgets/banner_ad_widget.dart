import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/premium_bloc/premium_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() async {
    // Ensure the Ad SDK is initialized before loading any ad
    await AdService().init();
    if (!mounted) return;

    final adSize = await AdService().getAdaptiveBannerSize(context);

    _bannerAd = AdService().createBannerAd(
      size: adSize,
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        _bannerAd = null;
        if (mounted) {
          setState(() {
            _isAdLoaded = false;
          });
        }
        // Retry loading after a delay (Exponential backoff handled in AdService ideally, 
        // but for banner we just retry after 30s)
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) _loadAd();
        });
      },
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, state) {
        if (state.isPremium) {
          return const SizedBox.shrink();
        }

        if (!_isAdLoaded || _bannerAd == null) {
          return const SizedBox.shrink();
        }

        return Container(
          alignment: Alignment.center,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }
}
