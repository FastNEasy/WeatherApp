import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/theme/theme_notifier.dart';
import 'package:weather_app/src/theme/theme_switch.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          ThemeSwitch(),
        ],
      ),
    );
  }
}
