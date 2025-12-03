import '../models/song.dart';
import '../services/lrclib_service.dart';
import 'file_service.dart';
import '../models/lyric_result.dart';
import 'dart:async';
import 'dart:io';

class LyricsService {
  /// Devuelve la letra ideal:
  /// - syncedLyrics (si disponible)
  /// - sino plainLyrics
  /// - sino null
  static Future<String?> fetchLyrics(Song song) async {
    try {
      // Llamada a LRCLib
      final result = await LRCLibService.getLyrics(
        artist: song.artist,
        title: song.title,
        album: song.album,
        durationSeconds: song.durationSeconds,
      );

      if (result == null) {
        print(">>> No se encontró letra para ${song.title}");
        return null;
      }

      // Preferir syncedLyrics
      if (result.syncedLyrics.isNotEmpty &&
          result.syncedLyrics.trim().isNotEmpty) {
        return result.syncedLyrics.trim();
      }

      // Si no hay synced, usar plainLyrics
      if (result.plainLyrics.isNotEmpty &&
          result.plainLyrics.trim().isNotEmpty) {
        return result.plainLyrics.trim();
      }

      return null;
    } catch (e) {
      print(">>> Error en fetchLyrics: $e");
      return null;
    }
  }

  /// Descarga y guarda en archivo .lrc
  static Future<bool> downloadAndSave(Song song) async {
    final lyrics = await fetchLyrics(song);

    if (lyrics == null) return false;

    await FileService.saveLRC(song.path, lyrics);
    return true;
  }

  static Future<bool> saveManualResult(Song song, LyricResult result) async {
    try {
      final String lyrics = result.syncedLyrics.isNotEmpty
          ? result.syncedLyrics
          : result.plainLyrics;
      if (lyrics.trim().isEmpty) return false;

      //obtener la ruta del archivo de la cancion
      final file = File(song.path);
      final filenamen = file.uri.pathSegments.last.split('.').first;
      final lrcPath = "${file.parent.path}/$filenamen.lrc";

      //guardar las letras en el archivo .lrc
      final lrcFile = File(lrcPath);
      await lrcFile.writeAsString(lyrics);
    } catch (e) {
      print(">>> Error en saveManualResult: $e");
      return false;
    }
    return true;
  }
}
