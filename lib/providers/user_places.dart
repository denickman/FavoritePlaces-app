import 'package:favoriteplaces/models/place_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favoriteplaces/models/place.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

// даёт доступ к системным директориям (и Android, и iOS).
import 'package:path_provider/path_provider.dart' as syspath;

// Dart-библиотека для работы со строками путей.
// отвечает за манипуляции с самим путём (имена файлов, склейка, расширения).
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  // Возвращает путь к стандартной системной директории, где должны храниться базы данных SQLite
  // (на iOS и Android у каждой платформы своё место).
  final dbPath = await sql.getDatabasesPath();

  // Открывает (или создаёт структуру таблицы, если ещё не существует) базу данных SQLite.
  return await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final places = data.map(
      (row) => Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lon'] as double,
          address: row['address'] as String,
        ),
      ),
    ).toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDirectory = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDirectory.path}/$filename');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();

    /*
      Добавляет новую строку в таблицу user_places.
      Вставляет данные о месте (id, title, путь к картинке, координаты и адрес).
      sqflite автоматически подставит всё в SQL-запрос:
    */

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
