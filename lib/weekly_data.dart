import 'dart:convert';

class WeeklyData {
  final double? lat;
  final double? long;
  final List<Daily>? daily;

  const WeeklyData({
    this.lat,
    this.long,
    this.daily,
  });
  factory WeeklyData.fromJson(Map<String, dynamic> json) {
    return WeeklyData(
      lat: double.tryParse("${json['lat']}"),
      long: double.tryParse("${json['lon']}"),
      daily: List<Daily>.from(json['daily'].map((x) => Daily.fromJson(x))),
    );
  }
}

//nested weather desc and icon object
class WeeklyWeather {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const WeeklyWeather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });
  factory WeeklyWeather.fromJson(Map<String, dynamic> json) {
    return WeeklyWeather(
      description: json['description'],
      icon: json['icon'],
    );
  }
}

//past 7 day weather, but one object- 1 day
class Daily {
  final Temp? temp;
  final int? timeStamp;
  //final int? pressure;
  // final int? humidity;
  //final double? windSpeed;
  final List<WeeklyWeather>? weather;

  const Daily({
    this.temp,
    //this.pressure,
    //this.humidity,
    //this.windSpeed,
    this.timeStamp,
    this.weather,
  });
  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      timeStamp: json['dt'],
      temp: Temp.fromJson(json['temp']),
      weather: List<WeeklyWeather>.from(
          json['weather'].map((x) => WeeklyWeather.fromJson(x))),
    );
  }
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
  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      dayTemp: double.tryParse("${json['day']}"),
      nightTemp: double.tryParse("${json['night']}"),
      maxTemp: double.tryParse("${json['max']}"),
      minTemp: double.tryParse("${json['min']}"),
    );
  }
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
