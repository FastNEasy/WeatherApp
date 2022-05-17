import 'dart:convert';

//Api for cities:
//http://api.openweathermap.org/geo/1.0/direct?q={CityName}&limit=5&appid=493c32b6d579efb49f3d9ead947c9dbb
List<CityData> cityDataFromJson(String str) =>
    List<CityData>.from(json.decode(str).map((x) => CityData.fromJson(x)));

class CityData {
  final String? name;
  final double? lat;
  final double? long;
  final String? country;

  CityData({
    this.name,
    this.lat,
    this.long,
    this.country,
  });
  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      name: json['name'],
      lat: double.tryParse("${json['lat']}"),
      long: double.tryParse("${json['lon']}"),
      country: json['country'],
    );
  }
}
