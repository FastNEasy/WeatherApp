import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/city_search/second_screen.dart';
import 'package:weather_app/src/favorites/fav_provider.dart';
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

  void removeFavorite() {}
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
            title: const Text("Favorites"),
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
              // FutureBuilder<List<Favorite>?>(
              //   future: items,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return ListView.builder(
              //         itemCount: snapshot.data?.length,
              //         itemBuilder: (context, index) {
              //           return ListTile(
              //             contentPadding:
              //                 EdgeInsets.only(left: 71.5, right: 16),
              //             title: Text(
              //                 snapshot.data?[index].city ?? "something wrong"),
              //             //leading: Icon(Icons.location_on),
              //             trailing: IconButton(
              //               icon: const Icon(Icons.remove),
              //               onPressed: removeFavorite,
              //             ),
              //           );
              //         },
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text("${snapshot.error}");
              //     }
              //     return const Text("Something went wrong");
              //   },
              // ),
            ],
          ),
          Divider(height: 0),
          ListTile(
            title: const Text("Weekly forecast"),
            onTap: onPressed,
            leading: const Icon(Icons.cloud),
          ),
          ListTile(
            title: const Text("Settings"),
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
