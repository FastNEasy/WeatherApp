import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Favorite {
  int? id;
  String? city;
  String? lat;
  String? lon;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "city": city,
      "lat": lat,
      "lon": lon,
    };
    if (id != null) map["id"] = id;
    return map;
  }

  Favorite({this.city, this.lat, this.lon});

  Favorite.fromMap(dynamic map) {
    id = map["id"];
    city = map["city"];
    lat = map["lat"];
    lon = map["lon"];
  }
}

class FavoriteProvider with ChangeNotifier {
  //class that handles db changes
  Database? db;
  List<Favorite>? favList = [];

  Future<void> init() async {
    var dbPath = join(await getDatabasesPath(), "favorite_database.db");
    await open(dbPath);
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE favorites ( 
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          city TEXT,
          lat TEXT,
          lon TEXT)
      ''');
    });
  }

  Future<void> insertFavorite(Favorite fav) async {
    fav.id = await db?.insert("favorites", fav.toMap());
    favList?.add(fav);
    print("Added favorite $fav with id ${fav.id}");
    notifyListeners();
  }

  Future<int?> delete(int id) async {
    return await db?.delete("favorites", where: 'id = ?', whereArgs: [id]);
  }

  Future<void> getFavorite({bool notify = true}) async {
    List<Map>? maps = await db?.query(
      "favorites",
      columns: ["id", "city", "lat", "lon"],
      // where: 'id = ?',
      //  whereArgs: [id]
    );

    if (maps != null) {
      favList = maps.map((e) => Favorite.fromMap(e)).toList();
      if (notify) notifyListeners();
    }
  }
}
