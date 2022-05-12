import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:weather_app/second_screen.dart';
import 'package:weather_app/weekly_data.dart';
import 'weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  Future<WeeklyData>? weekData;
  @override
  void initState() {
    super.initState();
    weekData = fetchWeekly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly weather for chosen place"),
      ),
      body: Center(
        child: FutureBuilder<WeeklyData>(
          future: weekData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.daily?.length,
                itemBuilder: (context, index) {
                  String tempStr =
                      timeStampToDate(snapshot.data?.daily?[index].timeStamp);
                  return Card(
                    child: ListTile(
                      title: Text("$tempStr with weather: "
                          "${snapshot.data?.daily?[index].weather?.first.description}"),
                      subtitle: Text(
                          "Day: ${snapshot.data?.daily?[index].temp?.dayTemp} C | "
                          "Night: ${snapshot.data?.daily?[index].temp?.nightTemp} C | "
                          "Min: ${snapshot.data?.daily?[index].temp?.minTemp} C | "
                          "Max: ${snapshot.data?.daily?[index].temp?.maxTemp} C"),
                      leading: Image.network(
                        "https://openweathermap.org/img/wn/${snapshot.data?.daily?[index].weather?.first.icon}@2x.png",
                        fit: BoxFit.fitHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.blueGrey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  String timeStampToDate(int? timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp! * 1000);
    String dateStr = "${date.day}.${date.month}.${date.year}";
    return dateStr;
  }
}

Future<WeeklyData> fetchWeekly() async {
  //print("Future things $coordinates");
  final prefs = await SharedPreferences.getInstance();
  final List<String>? items =
      prefs.getStringList("City") ?? ["Valmiera", "57.541", "25.4275"];
  print(items);
  Map<String, dynamic> qData = {
    'lat': items?[1],
    'lon': items?[2],
    'exclude': "minutely,hourly,current"
  };
  final response = await api.get('/2.5/onecall', queryParameters: qData);
  return WeeklyData.fromJson(response.data);
}

Dio api = Dio(BaseOptions(
    baseUrl: "https://api.openweathermap.org/data",
    queryParameters: {
      "appid": "493c32b6d579efb49f3d9ead947c9dbb",
      "units": "metric",
    }));
//new file and self init.