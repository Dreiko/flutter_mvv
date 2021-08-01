import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quiz/state_ads.dart';
import 'package:quiz/state_app.dart';
import 'package:quiz/state_navigation.dart';
import 'package:quiz/widget_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final adsInitializer = MobileAds.instance.initialize();
  final adsState = AdsState(adsInitializer);
  adsState.bottomBannerAd.loadBottomBanner();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BottomNavigationState()),
    ChangeNotifierProvider(create: (context) => adsState.bottomBannerAd),
    ChangeNotifierProvider(create: (context) => adsState.attemptRewardAd),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bottomNavigationState = Provider.of<BottomNavigationState>(context, listen: false);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigator(
          pages: [MaterialPage(key: ValueKey('home'), child: HomePageWidget(title: 'home'))],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            return bottomNavigationState.pop();
          }),
    );
  }
}
