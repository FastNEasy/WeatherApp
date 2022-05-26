import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title.lang': "Language:",
      'title.theme': "Dark/Light theme",
      'title.settings': "Settings",
      'drawer.weekly': "Weekly forecast",
      'drawer.settings': "Settings",
      'drawer.favorites': "Favorites",
    },
    'lv': {
      'title.lang': "Valoda:",
      'title.theme': "Tumšs/Gaišs motīvs",
      'title.settings': "Iestatījumi",
      'drawer.weekly': "Laikapstākļi nedēļai",
      'drawer.settings': "Iestatījumi",
      'drawer.favorites': "Mīļākās lokācijas",
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get titleLang {
    return _localizedValues[locale.languageCode]!['title.lang']!;
  }

  String get titleTheme {
    return _localizedValues[locale.languageCode]!['title.theme']!;
  }

  String get titleSettings {
    return _localizedValues[locale.languageCode]!['title.settings']!;
  }

  String get drawerWeekly {
    return _localizedValues[locale.languageCode]!['drawer.weekly']!;
  }

  String get drawerSettings {
    return _localizedValues[locale.languageCode]!['drawer.settings']!;
  }

  String get drawerFavorites {
    return _localizedValues[locale.languageCode]!['drawer.favorites']!;
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      DemoLocalizations.languages().contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
