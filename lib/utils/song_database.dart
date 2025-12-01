import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/song.dart';

class SongDatabase {
  static Future<String> _getDbPath() async {
    final dir = await getExternalStorageDirectory();
    // Te da: /storage/emulated/0/Android/data/com.example.lyrio/files
    final lyrioDir = Directory("${dir!.path}/lyrio");

    if (!lyrioDir.existsSync()) {
      await lyrioDir.create(recursive: true);
    }

    return "${lyrioDir.path}/songs.json";
  }

  /// Guarda canciones
  static Future<void> save(List<Song> songs) async {
    final path = await _getDbPath();
    final file = File(path);

    final jsonList = songs.map((s) => s.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  /// Carga canciones
  static Future<List<Song>> load() async {
    final path = await _getDbPath();
    final file = File(path);

    if (!file.existsSync()) {
      return [];
    }

    try {
      final raw = await file.readAsString();
      final decoded = json.decode(raw);

      if (decoded is List) {
        return decoded.map((e) => Song.fromJson(e)).toList();
      }
    } catch (_) {}

    return [];
  }
}
