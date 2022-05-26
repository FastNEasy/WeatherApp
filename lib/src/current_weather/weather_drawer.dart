import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/city_search/second_screen.dart';
import 'package:weather_app/src/favorites/fav_provider.dart';
import 'package:weather_app/src/lang_translations/localisation_delegate.dart';
import 'package:weather_app/src/settings/settings_screen.dart';
import 'package:weather_app/src/weekly_weather/weekly_screen.dart';

class WeatherDrawer extends StatefulWidget {
  const WeatherDrawer({Key? key}) : super(key: key);
  @override
  State<WeatherDrawer> createState() => _WeatherDrawerState();
}

class _WeatherDrawerState extends State<WeatherDrawer> {
  void onPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WeeklyScreen(),
        ));
  }

  void addFavorite(BuildContext context) async {
    List<String>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );

    if (result != null) {
      print("In the drawer: $result");
      context.read<FavoriteProvider>().insertFavorite(
          (Favorite(city: result[0], lat: result[1], lon: result[2])));
    }
  }

  void removeFavorite(int id) {
    context.read<FavoriteProvider>().delete(id);
  }

  void onSettingsPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsWidget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text("I am a drawer"),
            margin: EdgeInsets.zero,
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).drawerFavorites),
            leading: const Icon(Icons.star),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                addFavorite(context);
              },
            ),
          ),
          Divider(height: 0),
          Column(
            children: [
              SizedBox(
                child: Consumer<FavoriteProvider>(
                  builder: ((context, value, child) {
                    if (value.favList!.isNotEmpty) {
                      return ListTile(
                        title: Text("${value.favList?.first.city}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            removeFavorite(value.favList?.first.id ?? 0);
                          },
                        ),
                      );
                    }
                    return const Text("Nothing selected");
                  }),
                ),
              ),
            ],
          ),
          Divider(height: 0),
          ListTile(
            title: Text(DemoLocalizations.of(context).drawerWeekly),
            onTap: onPressed,
            leading: const Icon(Icons.cloud),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).drawerSettings),
            onTap: () {
              print("Go to settings");
              onSettingsPressed();
            },
            leading: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
