import 'package:dio/dio.dart';
import '../data_class/city_data.dart';
import '../data_class/weather_data.dart';
import '../data_class/weekly_data.dart';

class Api {
  Api._();
  static final Api client = Api._();

  Dio api = Dio(
      BaseOptions(baseUrl: "https://api.openweathermap.org/", queryParameters: {
    "appid": "493c32b6d579efb49f3d9ead947c9dbb",
    "units": "metric",
  }));

  //city request
  Future<List<CityData>> fetchCity(String city) async {
    //"http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb";
    Map<String, dynamic> qData = {
      'q': city,
      'limit': 5,
    };
    final response = await api.get("geo/1.0/direct", queryParameters: qData);
    var cityData = response.data;
    List<CityData> temp =
        (cityData as List).map((item) => CityData.fromJson(item)).toList();
    return temp;
  }

  //current weather request
  Future<WeatherData> fetchWeather(String lat, String long) async {
    Map<String, dynamic> qData = {
      'lat': lat,
      'lon': long,
      'exclude': "minutely,hourly,daily"
    };
    //"https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&exclude=minutely,hourly,daily";
    final response = await api.get('data/2.5/onecall', queryParameters: qData);
    return WeatherData.fromJson(response.data);
  }

  //daily weather
  Future<WeeklyData> fetchWeekly(String lat, String long) async {
    //print("Future things $coordinates");
    Map<String, dynamic> qData = {
      'lat': lat,
      'lon': long,
      'exclude': "minutely,hourly,current"
    };
    final response = await api.get('data/2.5/onecall', queryParameters: qData);
    return WeeklyData.fromJson(response.data);
  }
}
