import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../services/file_service.dart';
import '../models/song.dart';
import '../services/lyrics_service.dart'; // <-- Asegúrate de tenerlo
import '../utils/app_storage.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
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
    final lrc = File("${file.parent.path}/$base.lrc");
    return lrc.existsSync();
  }

  Future<void> downloadOne(Song song) async {
    final lyrics = await LyricsService.fetchLyrics(song);

    if (lyrics == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No se encontró la letra.")));
      return;
    }

    await FileService.saveLRC(song.path, lyrics);

    setState(() {}); // Refresca los iconos ✓
  }

  Future<void> downloadAll() async {
    if (songs.isEmpty) return;

    setState(() {
      downloadingAll = true;
      progress = 0;
    });

    for (int i = 0; i < songs.length; i++) {
      final s = songs[i];

      final lyrics = await LyricsService.fetchLyrics(s);
      if (lyrics != null) {
        await FileService.saveLRC(s.path, lyrics);
      }

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
            "Letras",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            // ====== BOTÓN DESCARGAR TODAS ======
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

            // ====== PROGRESO ======
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

            // ====== LISTA ======
            Expanded(
              child: songs.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay canciones.\nVe a Biblioteca para cargar.",
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),

                          // ---------- CARÁTULA ----------
                          leading: song.artwork != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white70,
                                  ),
                                ),

                          // ---------- TÍTULO ----------
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

                          // ---------- BOTÓN DESCARGAR / ICONO ✔ ----------
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
