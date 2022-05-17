import 'package:flutter/material.dart';
import 'dart:async';
import 'package:weather_app/src/global_files/Api.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/data_class/weekly_data.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  Future<WeeklyData>? weekData;
  List<String>? lastSavedData;
  @override
  void initState() {
    super.initState();
    lastSavedData = Prefs.userPrefs?.getStringList("City") ??
        ["Valmiera", "57.541", "25.4275"];
    if (lastSavedData != null) {
      //print("${lastSavedData![1]}, ${lastSavedData![0]}");
      weekData = Api.client.fetchWeekly(lastSavedData![1], lastSavedData![2]);
    }
  }

  String timeStampToDate(int? timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp! * 1000);
    String dateStr = "${date.day}.${date.month}.${date.year}";
    return dateStr;
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
}
