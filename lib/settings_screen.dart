import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/prefs.dart';
import 'package:weather_app/theme_notifier.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
              title: const Text("Dark/Light theme"),
              value: themeChanged,
              onChanged: (value) {
                setState(() {
                  themeChanged = value;
                });
                updateThemeSwitch(value);
                print("Theme is: $themeChanged");
              }),
        ],
      ),
    );
  }
}
