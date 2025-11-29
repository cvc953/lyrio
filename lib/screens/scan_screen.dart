import 'package:flutter/material.dart';
import '../utils/folder_picker.dart';
import '../services/file_service.dart';
import '../services/lrclib_service.dart';
import '../widgets/song_tile.dart';
import '../widgets/gradient_background.dart';
import '../models/song.dart';
import '../utils/permissions.dart';
import '../utils/app_storage.dart';
import '../utils/lyrics_utils.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<Song> songs = [];
  bool loading = false;
  bool downloadingAll = false;
  double progress = 0;

  String? folderPath;

  final Set<String> downloadingSongs = {};

  @override
  void initState() {
    super.initState();
    loadSavedFolder();
  }

  Future<void> loadSavedFolder() async {
    final saved = await AppStorage.loadFolder();
    if (saved != null) setState(() => folderPath = saved);
  }

  Future<void> pickFolder() async {
    final path = await FolderPicker.pickFolder();

    if (path != null) {
      setState(() => folderPath = path);
      await AppStorage.saveFolder(path);
    }
  }

  Future<void> scan() async {
    if (folderPath == null) return;

    setState(() => loading = true);

    await AppPermissions.requestStorage();
    songs = await FileService.scanMusic(folderPath!);

    setState(() => loading = false);
  }

  Future<void> downloadAll() async {
    setState(() {
      downloadingAll = true;
      progress = 0;
    });

    int done = 0;

    for (final s in songs) {
      await downloadSong(s);
      done++;
      setState(() => progress = done / songs.length);
    }

    setState(() => downloadingAll = false);
  }

  Future<void> downloadSong(Song song) async {
    setState(() => downloadingSongs.add(song.path));

    final result = await LRCLibService.getLyrics(
      artist: song.artist,
      title: song.title,
      album: song.album,
      durationSeconds: song.durationSeconds,
    );

    if (result != null) {
      final lyrics = pickBestLyrics(
        result.syncedLyrics ?? "",
        result.plainLyrics ?? "",
      );

      if (lyrics.isNotEmpty) {
        await FileService.saveLRC(song.path, lyrics);
      }
    }
    setState(() => downloadingSongs.remove(song.path));
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Tus canciones"),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: downloadAll,
          backgroundColor: Colors.orange,
          label: const Text("Descargar todo"),
          icon: const Icon(Icons.download),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: pickFolder,
                  child: const Text("Seleccionar carpeta"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: scan, child: const Text("Escanear")),
              ],
            ),
            const SizedBox(height: 10),
            if (downloadingAll)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Descargando letras..."),
                    LinearProgressIndicator(value: progress),
                  ],
                ),
              ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (_, i) {
                        final song = songs[i];
                        return SongTile(
                          song: song,
                          downloading: downloadingSongs.contains(song.path),
                          onDownload: () => downloadSong(song),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
