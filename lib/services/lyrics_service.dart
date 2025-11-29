import '../models/song.dart';
import '../services/lrclib_service.dart';
import '../services/file_service.dart';
import '../models/lyric_result.dart';

class LyricsService {
  /// Devuelve la letra ideal:
  /// - syncedLyrics (si disponible)
  /// - sino plainLyrics
  /// - sino null
  static Future<String?> fetchLyrics(Song song) async {
    try {
      // Llamada a LRCLib
      final LyricResult? result = await LRCLibService.getLyrics(
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
      if (result.syncedLyrics != null &&
          result.syncedLyrics!.trim().isNotEmpty) {
        return result.syncedLyrics!.trim();
      }

      // Si no hay synced, usar plainLyrics
      if (result.plainLyrics != null && result.plainLyrics!.trim().isNotEmpty) {
        return result.plainLyrics!.trim();
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
}
