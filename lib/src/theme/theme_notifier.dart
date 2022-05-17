import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';

class ThemeNotifier with ChangeNotifier {
  bool _themeChange = false;
  bool get themeChange => _themeChange;

  void themeChanged() {
    _themeChange = Prefs.userPrefs?.getBool("Theme") ?? false;
    notifyListeners();
  }
}
