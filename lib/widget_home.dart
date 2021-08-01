import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quiz/state_ads.dart';
import 'package:quiz/state_navigation.dart';

class HomePageWidget extends StatelessWidget {
  HomePageWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _createContent()),
            _createBottomBannerWidget(),
          ],
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: _createFloatingActionButton()
        ),
        bottomNavigationBar: Consumer<BottomNavigationState>(
          builder: (context, state, child) {
            return BottomNavigationBar(
              elevation: 8,
              items: [
                BottomNavigationBarItem(label: "Quiz", icon: Icon(Icons.quiz)),
                BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
              ],
              currentIndex: state.value.index,
              onTap: (index) => state.bottomTap(index),
            );
          },
        ));
  }

  Widget _createFloatingActionButton() {
    return Consumer<AttemptRewardState>(builder: (context, state, child) {
      final themeData = Theme.of(context);

      if (state.loading) {
        return FloatingActionButton(
            onPressed: null,
            tooltip: 'Add attempt',
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: themeData.buttonColor,
                backgroundColor: themeData.primaryColor,
                strokeWidth: 2.0,
              ),
            ));
      } else {
        return FloatingActionButton(
          onPressed: () => state.loadAttemptRewardedAd(),
          tooltip: 'Add attempt',
          child: Icon(Icons.add),
        );
      }
    });
  }

  Widget _createContent() {
    return Consumer<AttemptRewardState>(builder: (context, state, child) {
      final themeData = Theme.of(context);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Attempts',
          ),
          Text(
            '${state.attempts}',
            style: themeData.textTheme.headline4,
          ),
        ],
      );
    });
  }

  Widget _createBottomBannerWidget() {
    return Consumer<BottomBannerState>(builder: (context, state, child) {
      final ad = state.ad;
      if (ad == null)
        return SizedBox(height: 50);
      else
        return Container(
          height: 50,
          child: AdWidget(ad: ad),
        );
    });
  }
}
