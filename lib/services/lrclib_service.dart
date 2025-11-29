import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/lyric_result.dart';

class LRCLibService {
  static const String base = "https://lrclib.net/api/get";

  static Future<LyricResult?> getLyrics({
    required String artist,
    required String title,
    required String album,
    required int durationSeconds,
  }) async {
    //construir Url con parametros exactos para lrclib
    final uri = Uri.parse(
      "$base/get?artist_name=${Uri.encodeComponent(artist)}"
      "&track_name=${Uri.encodeComponent(title)}"
      "&album_name=${Uri.encodeComponent(album)}"
      "&duration=$durationSeconds",
    );

    final r = await http.get(uri);

    if (r.statusCode == 200 && r.body.isNotEmpty) {
      final data = json.decode(r.body);
      return LyricResult.fromJson(data);
    }
    return null;
  }
}
