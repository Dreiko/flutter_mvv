import 'package:flutter/widgets.dart';

class BottomNavigationState with ChangeNotifier {
  BottomNavigation _value = BottomNavigation.QUIZ;
  BottomNavigation get value => _value;

  bool pop() {
    return false;
  }

  void bottomTap(int index) {
    final newValue = index.bottomNavigation;
    if (_value != newValue) {
      _value = index.bottomNavigation;
      notifyListeners();
    }
  }
}

enum BottomNavigation {
  QUIZ,
  PROFILE
}

extension _BottomNavigation on int {
  BottomNavigation get bottomNavigation {
    switch (this) {
      case 0:
        return BottomNavigation.QUIZ;
      case 1:
        return BottomNavigation.PROFILE;
      default :
        throw ArgumentError.value(this, "Illegal BottomNavigation index");
    }
  }
}
