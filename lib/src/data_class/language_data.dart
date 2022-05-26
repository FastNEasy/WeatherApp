import 'dart:convert';

class LanguageData {
  final String? langTitle;
  final String? settings;

  LanguageData({
    this.langTitle,
    this.settings,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) {
    return LanguageData(
      langTitle: json['titles.languages'],
      settings: json['table.settings'],
    );
  }
}
