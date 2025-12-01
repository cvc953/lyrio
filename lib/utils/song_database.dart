import 'dart:convert';
import 'dart:io';
import '../models/song.dart';

class SongDatabase {
  static final String dbPath =
      "/storage/emulated/0/lyrio/data/songs.json"; // carpeta propia

  /// Guarda la lista completa de canciones en un archivo JSON
  static Future<void> save(List<Song> songs) async {
    final file = File(dbPath);

    await file.create(recursive: true);

    final jsonList = songs.map((s) => s.toJson()).toList();

    await file.writeAsString(json.encode(jsonList));
  }

  /// Carga las canciones desde el archivo JSON
  static Future<List<Song>> load() async {
    final file = File(dbPath);

    if (!file.existsSync()) {
      return [];
    }

    try {
      final jsonList = json.decode(await file.readAsString()) as List;
      return jsonList.map((e) => Song.fromJson(e)).toList();
    } catch (e) {
      // Si ocurre un error → retorna lista vacía para evitar crash
      return [];
    }
  }
}
