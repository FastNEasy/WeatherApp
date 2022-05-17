import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/current_weather/weather_drawer.dart';
import 'package:weather_app/src/favorites/fav_provider.dart';
import 'package:weather_app/src/global_files/prefs.dart';
import 'package:weather_app/src/current_weather/weather_dashboard.dart';
import 'package:weather_app/src/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();

  FavoriteProvider favoriteProvider = FavoriteProvider();
  await favoriteProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider.value(value: favoriteProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isThemeChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, value, child) {
        return MaterialApp(
          title: "My weather app",
          home: child,
          theme: ThemeData(
            //TODO: make this app wide
            fontFamily: 'LibreBodoni',
            brightness: value.themeChange ? Brightness.light : Brightness.dark,
          ),
        );
      },
      child: WeatherDashboard(),
    );
  }
}
