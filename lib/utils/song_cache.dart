import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class SongCache {
  static const _key = "cached_songs";

  static Future<void> saveSongs(List<Song> songs) async {
    final prefs = await SharedPreferences.getInstance();

    final list = songs.map((s) => s.toJson()).toList();
    final jsonStr = json.encode(list);

    await prefs.setString(_key, jsonStr);
  }

  static Future<List<Song>> loadSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);

    if (jsonStr == null) return [];

    final List<dynamic> list = json.decode(jsonStr);
    return list.map((item) => Song.fromJson(item)).toList();
  }
}
