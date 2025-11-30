import 'dart:io';
import 'package:metadata_god/metadata_god.dart';
import '../models/song.dart';

class FileService {
  static List<Song> librarySongs = [];
  static Future<List<Song>> scanMusic(String rootPath) async {
    final dir = Directory(rootPath);
    List<Song> songs = [];

    await for (var entity in dir.list(recursive: true)) {
      if (entity is File &&
          (entity.path.endsWith(".mp3") ||
              entity.path.endsWith(".flac") ||
              entity.path.endsWith(".m4a") ||
              entity.path.endsWith(".wav"))) {
        try {
          final metadata = await MetadataGod.readMetadata(file: entity.path);

          final title =
              metadata.title ??
              entity.uri.pathSegments.last.replaceAll(
                RegExp(r'\.(mp3|flac|m4a|wav)$'),
                '',
              );

          final artist = metadata.artist ?? "Unknown Artist";
          final album = metadata.album ?? "Unknown Album";
          final durationMs = metadata.durationMs ?? 0;
          final artworkBytes = metadata.picture?.data;

          songs.add(
            Song(
              path: entity.path,
              title: title,
              artist: artist,
              album: album,
              durationSeconds: (durationMs / 1000).round(),
              artwork: metadata.picture?.data,
            ),
          );
        } catch (e) {
          final filename = entity.uri.pathSegments.last;
          songs.add(
            Song(
              path: entity.path,
              title: filename.replaceAll(RegExp(r'\.(mp3|flac|m4a|wav)$'), ''),
              artist: "",
              album: "",
              durationSeconds: 0,
              artwork: null,
            ),
          );
        }
      }
    }
    librarySongs = songs;
    await SongCache.saveSongs(songs);
    return songs;
  }

  static Future<void> saveLRC(String songPath, String lyrics) async {
    final file = File(songPath);
    final dir = file.parent.path;

    final base = file.uri.pathSegments.last.split('.').first;
    final lrcPath = "$dir/$base.lrc";

    final lrcFile = File(lrcPath);
    await lrcFile.writeAsString(lyrics);
  }
}
