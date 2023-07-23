import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/ads.dart';

class GoogleAds {
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  /// Loads an interstitial ad.
  void loadAdInterstitial({bool showAfterLoad = false}) {
    InterstitialAd.load(
        adUnitId: AdKeys.interstitialAd1,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            interstitialAd = ad;
            if (showAfterLoad) {
              showInterstitialAd();
            }
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }

  void loadAdBanner({required VoidCallback adLoaded}) {
    bannerAd = BannerAd(
      adUnitId: AdKeys.bannerAd1,
      request: const AdRequest(),
      size: AdSize.fullBanner, //küçük bir reklam istersek bu boyutta
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          adLoaded();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void bannerDispose() {
    if (bannerAd != null) {
      bannerAd!.dispose();
    }
  }

  void interDispose() {
    if (interstitialAd != null) {
      interstitialAd!.dispose();
    }
  }
}
