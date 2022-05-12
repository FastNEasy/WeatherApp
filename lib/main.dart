import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:weather_app/prefs.dart';
import 'package:weather_app/second_screen.dart';
import 'package:weather_app/weekly_screen.dart';
import 'weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/Api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My weather app",
      home: MainWidget(),
      theme: ThemeData(
        //TODO: make this app wide
        fontFamily: 'LibreBodoni',
        brightness: Brightness.dark,
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  Future<WeatherData>? weatherData;
  List<String>? lastSavedData;
  bool locEnabled = false;

  @override
  void initState() {
    super.initState();
    locEnabled = Prefs.userPrefs?.getBool("isLocation") ?? false;
    lastSavedData = Prefs.userPrefs?.getStringList("City") ??
        ["Valmiera", "57.541", "25.4275"];
    if (lastSavedData != null) {
      if (locEnabled) {
        //get user location
        requestCurrentLocWeather();
      } else {
        //fetch current weather of pref loc
        requestCurrentWeather();
      }
    }
  }

  void requestCurrentLocWeather() async {
    try {
      String name = "Your location";
      Position uPos = await _determinePosition();
      String lat = uPos.latitude.toStringAsFixed(4);
      String lng = uPos.longitude.toStringAsFixed(4);
      Prefs.userPrefs?.setStringList("City", [name, lat, lng]);
      setState(() {
        weatherData = Api.client.fetchWeather(lat, lng);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while loading data')));
    }
  }

  void requestCurrentWeather() {
    setState(() {
      weatherData =
          Api.client.fetchWeather(lastSavedData![1], lastSavedData![2]);
    });
  }

  void updateLocButton(bool result) {
    Prefs.userPrefs?.setBool("isLocation", result);
    locEnabled = result;
  }

  void toggleLocation() async {
    setState(() {
      if (locEnabled) {
        updateLocButton(false);
      } else {
        updateLocButton(true);
        requestCurrentLocWeather();
      }
    });
  }

  Future<void> onRefresh() async {
    setState(() {
      if (locEnabled) {
        requestCurrentLocWeather();
      } else {
        requestCurrentWeather();
      }
    });
  }

  void onSearch(BuildContext context) async {
    List<String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );

    if (result != null) {
      lastSavedData = result;
    }
    setState(() {
      requestCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to weather!"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            onPressed: !locEnabled
                ? () {
                    onSearch(context);
                  }
                : null,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: toggleLocation,
            icon: const Icon(Icons.location_pin),
            color: locEnabled ? Colors.green : Colors.white,
          ),
        ],
      ),
      body: WeatherWidget(
        weatherData: weatherData,
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({this.weatherData, Key? key}) : super(key: key);
  final Future<WeatherData>? weatherData;
  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String? cityName;
  @override
  void initState() {
    super.initState();
    cityName = Prefs.userPrefs?.getStringList("City")?[0] ?? 'Valmiera';
  }

  void onPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WeeklyScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: widget.weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.network(
                            "https://openweathermap.org/img/wn/${snapshot.data?.current?.weather?.first.icon}@2x.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          "$cityName",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "${snapshot.data?.current?.weather?.first.description}",
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(
                          "Temperature (C): ${snapshot.data?.current?.temp}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Feels like (C): ${snapshot.data?.current?.feelsLike}",
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: onPressed,
                          child: const Text("Check weekly forecast!"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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

//position locator
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}


//new file and self init.