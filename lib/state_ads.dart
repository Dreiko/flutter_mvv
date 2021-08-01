import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsState {
  late BottomBannerState bottomBannerAd;
  late AttemptRewardState attemptRewardAd;

  AdsState(Future<InitializationStatus> s) {
    bottomBannerAd = BottomBannerState(s);
    attemptRewardAd = AttemptRewardState(s);
  }
}

class BottomBannerState with ChangeNotifier {
  static const String BottomBannerId = "ca-app-pub-6280198044419207/1743913937";

  BannerAd? _ad;
  BannerAd? get ad => _ad;

  Future<InitializationStatus> _initialisation;
  BottomBannerState(this._initialisation);

  void loadBottomBanner() {
    _initialisation.then((value) {
      _ad = BannerAd(
          adUnitId: _adUnitId,
          size: AdSize.banner,
          listener: _bannerAdListener,
          request: AdRequest()
      )..load();

      notifyListeners();
    });
  }

  String get _adUnitId {
    return BannerAd.testAdUnitId;
    // if (Platform.isAndroid) {
    //   return BannerId;
    // } else if (Platform.isIOS) {
    //   return BannerId;
    // } else {
    //   return '';
    // }
  }

  BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => log("onAdLoaded: ${ad.adUnitId}", ""),
    onAdFailedToLoad: (ad, error) => log("onAdFailedToLoad: ${ad.adUnitId}", "error: $error"),
    onAdOpened: (ad) => log("onAdOpened: ${ad.adUnitId}", ""),
    onAdClosed: (ad) => log("onAdClosed: ${ad.adUnitId}", ""),
    onAdWillDismissScreen: (ad) => log("onAdWillDismissScreen: ${ad.adUnitId}", ""),
    onAdImpression: (ad) => log("onAdImpression: ${ad.adUnitId}", ""),
    onPaidEvent: (ad, valueMicros, precision, currencyCode) => log(
        "onPaidEvent: ${ad.adUnitId}", "valueMicros: $valueMicros precision: $precision currencyCode: $currencyCode"),
  );

  static void log(String tag, String message) {
    print("BottomBannerAd: $tag: $message");
  }
}

class AttemptRewardState with ChangeNotifier {
  static const String AttemptRewardedId = "ca-app-pub-6280198044419207/1743913937";

  bool _loading = false;
  bool get loading => _loading;

  int _attempts = 0;
  int get attempts => _attempts;

  Future<InitializationStatus> _initialisation;
  AttemptRewardState(this._initialisation);

  void loadAttemptRewardedAd() {
    _initialisation.then((value) {
      _loading = true;
      notifyListeners();

      RewardedAd.load(
          adUnitId: _adUnitId,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
            developer.log("onAdLoaded: ${ad.adUnitId}", name: "AttemptRewardState");

            ad.fullScreenContentCallback = _fullScreenContentCallback;

            _loading = false;
            notifyListeners();

            ad.show(onUserEarnedReward: (ad, reward) {
              _attempts += reward.amount.toInt();
              notifyListeners();
            });
          }, onAdFailedToLoad: (error) {
            developer.log("onAdFailedToLoad: $error", name: "AttemptRewardState");

            _loading = false;
            notifyListeners();
          }));
    });
  }

  String get _adUnitId {
    return RewardedAd.testAdUnitId;
    // if (Platform.isAndroid) {
    //   return BannerId;
    // } else if (Platform.isIOS) {
    //   return BannerId;
    // } else {
    //   return '';
    // }
  }

  FullScreenContentCallback<RewardedAd> _fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (ad) {
      print('$ad onAdShowedFullScreenContent.');
    },
    onAdImpression: (ad) {
      print('$ad onAdImpression.');
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      print('$ad onAdFailedToShowFullScreenContent: $error.');
      ad.dispose();
    },
    onAdWillDismissFullScreenContent: (ad) {
      print('$ad onAdWillDismissFullScreenContent.');
    },
    onAdDismissedFullScreenContent: (ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
  );
}
