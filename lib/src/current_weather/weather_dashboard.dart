import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/src/global_files/Api.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/city_search/second_screen.dart';
import 'package:weather_app/src/current_weather/weather_display_data.dart';
import 'package:weather_app/src/current_weather/weather_drawer.dart';
import 'package:weather_app/src/data_class/weather_data.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({Key? key}) : super(key: key);

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  Future<WeatherData>? weatherData;
  List<String>? lastSavedData;
  bool locEnabled = false;
  String? cityName;

  @override
  void initState() {
    super.initState();
    locEnabled = Prefs.userPrefs?.getBool("isLocation") ?? false;
    lastSavedData = Prefs.userPrefs?.getStringList("City") ??
        ["Valmiera", "57.541", "25.4275"];
    if (lastSavedData != null) {
      cityName = Prefs.userPrefs?.getStringList("City")?[0] ?? 'Valmiera';
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
        lastSavedData = [name, lat, lng];
        cityName = name;
        weatherData = Api.client.fetchWeather(lat, lng);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error while loading data')));
    }
  }

  void requestCurrentWeather() {
    setState(() {
      cityName = lastSavedData![0];
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
        print("I am toggled on");
        updateLocButton(false);
      } else {
        print("I am toggled off");
        updateLocButton(true);
        //requestCurrentLocWeather();
      }
    });
  }

  Future<void> onRefresh() async {
    setState(() {
      if (locEnabled) {
        print("I am enabled!");
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
        cityName: cityName,
      ),
      drawer: WeatherDrawer(),
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
