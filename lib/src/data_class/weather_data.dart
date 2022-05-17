import 'dart:convert';

//Weather api request struct
//Api for weather icons:
//https://openweathermap.org/img/wn/{iconId}@2x.png

//Api for weather data from lat and long:
//https://api.openweathermap.org/data/2.5/onecall?lat={latCord}&lon={longCord}&exclude=minutely,hourly&units=metric&appid=493c32b6d579efb49f3d9ead947c9dbb
//TODO split up weather api request and limit to few data
//Api for cities:
//http://api.openweathermap.org/geo/1.0/direct?q={CityName}&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb

//main weather data
class WeatherData {
  final double? lat;
  final double? long;
  final Current? current;
  //final List<Daily>? daily;

  const WeatherData({
    this.lat,
    this.long,
    this.current,
    //this.daily,
  });
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      lat: double.tryParse("${json['lat']}"),
      long: double.tryParse("${json['lon']}"),
      current: Current.fromJson(json['current']),
    );
  }
}

//todays data
class Current {
  final double? temp;
  final double? feelsLike;
  final int? pressure;
  final int? humidity;
  final double? windSpeed;
  final List<Weather>? weather;

  const Current({
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.weather,
  });
  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      temp: double.tryParse("${json['temp']}"),
      feelsLike: double.tryParse("${json['feels_like']}"),
      weather:
          List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
    );
  }
}

//nested weather desc and icon object
class Weather {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'],
      icon: json['icon'],
    );
  }
}

//past 7 day weather, but one object- 1 day
class Daily {
  final Temp? temp;
  final int? pressure;
  final int? humidity;
  final double? windSpeed;
  final List<Weather>? weather;

  const Daily({
    this.temp,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.weather,
  });
  // factory Daily.fromJson(Map<String, dynamic> json) {
  //   return Daily(
  //     lat: double.tryParse("${json['lat']}"),
  //     long: double.tryParse("${json['lon']}"),
  //   );
  // }
}

//nested temperature for daily object
class Temp {
  final double? dayTemp;
  final double? nightTemp;
  final double? maxTemp;
  final double? minTemp;

  const Temp({
    this.dayTemp,
    this.nightTemp,
    this.maxTemp,
    this.minTemp,
  });
}

//nested feels like for daily object
class FeelsLike {
  final double? dayFeel;
  final double? nightFeel;

  const FeelsLike({
    this.dayFeel,
    this.nightFeel,
  });
}
