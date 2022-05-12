import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:weather_app/city_data.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/Api.dart';
import 'package:weather_app/prefs.dart';

//when changed typings, make a search list which will show finds

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<CityData>>? cityData;
  final TextEditingController filter = TextEditingController();
  Timer? timer;

  void setPrefs(double? lat, double? lng, String? name) async {
    String la = lat?.toStringAsFixed(4) ?? "57.541";
    String ln = lng?.toStringAsFixed(4) ?? "25.4275";
    String cityName = name ?? "Valmiera";
    Prefs.userPrefs?.setStringList("City", <String>[cityName, la, ln]);
  }

  void showSearchResults(String city) {
    timer?.cancel();
    timer = Timer(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          setState(
            () {
              cityData = Api.client.fetchCity(city);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search a city..",
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              return;
            } else {
              showSearchResults(value);
            }
            //last cancels and new starts
          },
          controller: filter,
        ),
      ),
      body: Center(
        child: FutureBuilder<List<CityData>>(
          future: cityData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data?[index].name}"),
                    subtitle: Text("${snapshot.data?[index].country}"),
                    onTap: () {
                      Map<String, dynamic> coords = {
                        "lat": snapshot.data?[index].lat,
                        "long": snapshot.data?[index].long,
                        "name": snapshot.data?[index].name,
                      };
                      setPrefs(
                        snapshot.data?[index].lat,
                        snapshot.data?[index].long,
                        snapshot.data?[index].name,
                      );
                      Navigator.of(context).pop(<String>[
                        snapshot.data?[index].name?.toString() ??
                            'Unknown city',
                        snapshot.data?[index].lat?.toString() ?? '',
                        snapshot.data?[index].long?.toString() ?? ''
                      ]);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return const Text("Nothings searched");
            }
            //const CircularProgressIndicator()
          },
        ),
      ),
    );
  }
}
