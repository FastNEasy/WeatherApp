import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';

class ThemeNotifier with ChangeNotifier {
  bool _themeChange = false;
  Locale? _langChange;

  bool get themeChange => _themeChange;
  Locale? get langChange => _langChange;

  void themeChanged() {
    _themeChange = Prefs.userPrefs?.getBool("Theme") ?? false;
    notifyListeners();
  }

  void langChanged(String? lang) {
    Prefs.userPrefs?.setString("Lang", lang!);
    _langChange = Locale(Prefs.userPrefs?.getString("Lang") ?? "en");
    notifyListeners();
  }
}
