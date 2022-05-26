import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/lang_translations/localisation_delegate.dart';
import 'package:weather_app/src/theme/theme_notifier.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool themeChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeChanged = Prefs.userPrefs?.getBool("Theme") ?? false;
  }

  void updateThemeSwitch(bool val) {
    Prefs.userPrefs?.setBool("Theme", val);
    context.read<ThemeNotifier>().themeChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(DemoLocalizations.of(context).titleTheme),
        value: themeChanged,
        onChanged: (value) {
          setState(() {
            themeChanged = value;
          });
          updateThemeSwitch(value);
          print("Theme is: $themeChanged");
        });
  }
}
