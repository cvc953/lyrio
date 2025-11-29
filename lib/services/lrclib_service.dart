import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lyric_result.dart';

class LRCLibService {
  static const String base = "https://lrclib.net/api";

  static Future<LyricResult?> getLyrics(String artist, String title) async {
    final url = Uri.parse("$base/get?artist=$artist&title=$title");
    final r = await http.get(url);

    if (r.statusCode == 200) {
      final data = json.decode(r.body);
      return LyricResult.fromJson(data);
    }
    return null;
  }
}
