import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants/ads.dart';

class GoogleAds {
  BannerAd? _bannerAd;
  late InterstitialAd? _interstitialAd;

  /// Loads an interstitial ad.
  void loadAdInterstitial({bool showAfterLoad = false}) {
    InterstitialAd.load(
        adUnitId: AdKeys.interstitialAd1,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            if (showAfterLoad) {
              showInterstitialAd();
            }
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  void loadAdBanner({required VoidCallback adLoaded}) {
    _bannerAd = BannerAd(
      adUnitId: AdKeys.bannerAd1,
      request: const AdRequest(),
      size: AdSize.banner, //küçük bir reklam istersek bu boyutta
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          adLoaded();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }
}
