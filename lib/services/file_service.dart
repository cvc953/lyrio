import 'dart:io';
import 'package:lyrio/utils/artwork_cache.dart';
import 'package:lyrio/utils/song_database.dart';
import 'package:metadata_god/metadata_god.dart';
import '../models/song.dart';
import 'dart:typed_data';

class FileService {
  static List<Song> librarySongs = [];

  static final List<String> _allowedExtensions = [
    ".mp3",
    ".flac",
    ".m4a",
    ".wav",
  ];

  static final List<String> _allowedFolders = [
    "Music",
    "Download",
    "Downloads",
    "Audio",
    "Audios",
    "Songs",
  ];

  static Future<void> scanMusicWithCallback(
    String rootPath, {
    required Function(String path, int scanned, int found) onScan,
  }) async {
    final dir = Directory(rootPath);
    List<Song> songs = [];

    int scanned = 0;

    await for (var entity in dir.list(recursive: true)) {
      scanned++;

      onScan(entity.path, scanned, songs.length);

      print("Leyendo: ${entity.path}");

      if (entity is File &&
          (entity.path.endsWith(".mp3") ||
              entity.path.endsWith(".flac") ||
              entity.path.endsWith(".m4a") ||
              entity.path.endsWith(".wav"))) {
        try {
          final metadata = await MetadataGod.readMetadata(file: entity.path);

          final art = metadata.picture?.data;

          if (metadata.picture?.data != null) {
            ArtworkCache.save(entity.path, metadata.picture!.data);
          }

          songs.add(
            Song(
              path: entity.path,
              title:
                  metadata.title ??
                  entity.uri.pathSegments.last.replaceAll(
                    RegExp(r'\.(mp3|flac|m4a|wav)$'),
                    '',
                  ),
              artist: metadata.artist ?? "",
              album: metadata.album ?? "",
              durationSeconds: (metadata.durationMs ?? 0) ~/ 1000,
            ),
          );
        } catch (_) {}
      }
    }

    librarySongs = songs;
    await SongDatabase.save(songs);
    final art = await ArtworkCache.load(songs[0].path);
  }

  static Future<void> saveLRC(String songPath, String lyrics) async {
    final file = File(songPath);
    final dir = file.parent.path;
    final base = file.uri.pathSegments.last.split('.').first;
    final lrcPath = "$dir/$base.lrc";

    final lrcFile = File(lrcPath);
    await lrcFile.writeAsString(lyrics);
  }

  static Future<Uint8List?> loadArtwork(String path) async {
    try {
      final meta = await MetadataGod.readMetadata(file: path);
      return meta.picture?.data;
    } catch (_) {
      return null;
    }
  }
}
