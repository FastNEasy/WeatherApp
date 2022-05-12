import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? userPrefs;
  static Future<void> init() async {
    userPrefs ??= await SharedPreferences.getInstance();
  }
}
