import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class SongCache {
  static const String _key = "cached_songs";

  // Guardar lista completa
  static Future<void> saveSongs(List<Song> songs) async {
    final prefs = await SharedPreferences.getInstance();
    final list = songs.map((e) => e.toJson()).toList();
    final jsonStr = json.encode(list);
    await prefs.setString(_key, jsonStr);
  }

  // Cargar canciones guardadas
  static Future<List<Song>> loadSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);

    if (jsonStr == null) return [];

    final List<dynamic> data = json.decode(jsonStr);

    return data.map((e) => Song.fromJson(e)).toList();
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
