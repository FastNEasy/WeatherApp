import 'package:dio/dio.dart';
import 'package:weather_app/src/data_class/language_data.dart';

class LangApi {
  LangApi._();
  static final LangApi client = LangApi._();

  Dio api = Dio(BaseOptions(
      baseUrl: "https://krava-staging.vaks.lv/api/translations/",
      queryParameters: {}));

  Future<List<LanguageData>> fetchTranslation(String lang) async {
    final response = await api.get(lang);
    var langTranslation = response.data;
    List<LanguageData> temp = (langTranslation as List)
        .map((item) => LanguageData.fromJson(item))
        .toList();
    return temp;
  }
}
