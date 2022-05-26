import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/lang_translations/localisation_delegate.dart';
import 'package:weather_app/src/theme/theme_notifier.dart';

class LangSwitch extends StatefulWidget {
  const LangSwitch({Key? key}) : super(key: key);

  @override
  State<LangSwitch> createState() => _LangSwitchState();
}

class _LangSwitchState extends State<LangSwitch> {
  String? dropdownvalue = "en";
  var items = [
    'lv',
    'en',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownvalue = Prefs.userPrefs?.getString("Lang") ?? "en";
  }

  void updateLanguageChoice(String? choice) {
    context.read<ThemeNotifier>().langChanged(choice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(DemoLocalizations.of(context).titleLang),
            DropdownButton(
              value: dropdownvalue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue;
                });
                updateLanguageChoice(newValue);
              },
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }
}
