import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lyric_result.dart';

class LRCLibService {
  static Future<LyricResult?> getLyrics({
    required String artist,
    required String title,
    required String album,
    required int durationSeconds,
  }) async {
    // Normalizar strings para evitar fallos
    final safeArtist = (artist.isEmpty) ? "" : artist.trim();
    final safeTitle = (title.isEmpty) ? "" : title.trim();
    final safeAlbum = (album.isEmpty) ? "" : album.trim();

    // duration debe ser double
    final safeDuration = (durationSeconds <= 0)
        ? ""
        : durationSeconds.toString();

    final uri = Uri.parse(
      "https://lrclib.net/api/get"
      "?artist_name=${Uri.encodeComponent(safeArtist)}"
      "&track_name=${Uri.encodeComponent(safeTitle)}"
      "&album_name=${Uri.encodeComponent(safeAlbum)}"
      "&duration=$safeDuration",
    );

    print(">>> LRC URL: $uri"); // Debug temporal

    final r = await http.get(uri);

    if (r.statusCode == 200 && r.body.isNotEmpty && r.body != "{}") {
      return LyricResult.fromJson(json.decode(r.body));
    }

    // Si la consulta exacta falla → hacer fallback a search
    return await _fallbackSearch(safeArtist, safeTitle);
  }

  // Búsqueda alternativa si get no encuentra nada
  static Future<LyricResult?> _fallbackSearch(
    String artist,
    String title,
  ) async {
    final query = Uri.encodeComponent("$artist $title");

    final searchUri = Uri.parse("https://lrclib.net/api/search?q=$query");
    final r = await http.get(searchUri);

    if (r.statusCode != 200) return null;

    final results = json.decode(r.body);
    if (results is List && results.isNotEmpty) {
      final match = results.first;
      return LyricResult.fromJson(match);
    }

    return null;
  }
}
