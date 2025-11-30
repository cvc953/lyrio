import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../services/file_service.dart';
import '../services/lyrics_service.dart';
import '../models/song.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Song> songs = [];
  bool downloadingAll = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() {
    songs = FileService.librarySongs;
    setState(() {});
  }

  bool hasLrc(Song song) {
    final file = File(song.path);
    final base = file.uri.pathSegments.last.split('.').first;
    return File("${file.parent.path}/$base.lrc").existsSync();
  }

  Future<void> downloadOne(Song song) async {
    final ok = await LyricsService.downloadAndSave(song);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se encontró letra para ${song.title}")),
      );
      return;
    }

    setState(() {}); // refrescar check verde
  }

  Future<void> downloadAll() async {
    if (songs.isEmpty) return;

    setState(() {
      downloadingAll = true;
      progress = 0;
    });

    for (int i = 0; i < songs.length; i++) {
      final ok = await LyricsService.downloadAndSave(songs[i]);
      setState(() {
        progress = (i + 1) / songs.length;
      });
    }

    setState(() {
      downloadingAll = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Descarga completa.")));
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Biblioteca",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            // ===== BOTÓN DESCARGAR TODAS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: downloadingAll ? null : downloadAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  downloadingAll ? "Descargando..." : "Descargar todas",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            // ===== PROGRESO =====
            if (downloadingAll)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: progress,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white24,
                ),
              ),

            const SizedBox(height: 10),

            // ===== LISTA DE CANCIONES =====
            Expanded(
              child: songs.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay canciones.\nEscanea desde Más.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (_, i) {
                        final song = songs[i];
                        final lrcExists = hasLrc(song);

                        return ListTile(
                          leading: song.artwork != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    song.artwork!,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white70,
                                  ),
                                ),
                          title: Text(
                            song.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: lrcExists
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => downloadOne(song),
                                ),
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
