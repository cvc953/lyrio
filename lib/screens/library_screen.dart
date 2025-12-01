import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../services/file_service.dart';
import '../services/lyrics_service.dart';
import '../models/song.dart';
import 'lyrics_viewer.dart';
import 'dart:typed_data';
import '../services/download_manager.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Song> allSongs = [];
  List<Song> filteredSongs = [];
  bool downloadingAll = false;
  double progress = 0.0;
  Set<String> downloadingSongs = {};

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() {
    allSongs = FileService.librarySongs;
    filteredSongs = List.from(allSongs);
    setState(() {});
  }

  void filterSongs(String query) {
    query = query.toLowerCase();

    setState(() {
      filteredSongs = allSongs.where((song) {
        return song.title.toLowerCase().contains(query) ||
            song.artist.toLowerCase().contains(query) ||
            song.album.toLowerCase().contains(query);
      }).toList();
    });
  }

  bool hasLrc(Song song) {
    final file = File(song.path);
    final base = file.uri.pathSegments.last.split('.').first;
    return File("${file.parent.path}/$base.lrc").existsSync();
  }

  Future<void> downloadOne(Song song) async {
    setState(() {
      downloadingSongs.add(song.path);
    });

    final ok = await LyricsService.downloadAndSave(song);

    setState(() {
      downloadingSongs.remove(song.path);
    });

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se encontró letra para ${song.title}")),
      );
      return;
    }

    setState(() {}); // refrescar check verde
  }

  Future<void> downloadPool(List<Song> songs, int poolSize) async {
    final pending = List<Song>.from(songs);

    // tareas activas
    final active = <Future>[];

    // contador para actualizar progreso
    int completed = 0;

    Future<void> startTask(Song song) async {
      setState(() {
        downloadingSongs.add(song.path);
      });

      await LyricsService.downloadAndSave(song);

      setState(() {
        downloadingSongs.remove(song.path);
      });

      completed++;

      setState(() {
        progress = completed / songs.length;
      });
    }

    while (pending.isNotEmpty || active.isNotEmpty) {
      // Llenar el pool con máximo poolSize descargas
      while (pending.isNotEmpty && active.length < poolSize) {
        final song = pending.removeAt(0);
        final task = startTask(song);
        active.add(task);

        // Cuando termine → eliminar del pool
        task.whenComplete(() {
          active.remove(task);
        });
      }

      // Esperar 20ms entre ciclos (suave y eficiente)
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  Future<void> downloadAll() async {
    final listToDownload = filteredSongs.isNotEmpty ? filteredSongs : allSongs;

    // Escuchar progreso
    DownloadManager().progressStream.listen((p) {
      setState(() => progress = p);
    });

    setState(() {
      downloadingAll = true;
    });

    await DownloadManager().downloadAll(listToDownload);

    setState(() {
      downloadingAll = false;
      progress = 0;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Descarga completa.")));

    loadSongs();
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            // 🔍 BUSCADOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextField(
                onChanged: filterSongs,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Buscar canción, artista o álbum...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            // BOTÓN DESCARGAR TODAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: downloadingAll ? null : downloadAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  downloadingAll ? "Descargando..." : "Descargar todas",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // PROGRESO GLOBAL
            if (downloadingAll)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: progress,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

            const SizedBox(height: 10),

            // LISTA FILTRADA
            Expanded(
              child: filteredSongs.isEmpty
                  ? const Center(
                      child: Text(
                        "No se encontraron canciones.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredSongs.length,
                      itemBuilder: (_, i) {
                        final song = filteredSongs[i];
                        final lrcExists = hasLrc(song);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LyricsViewer(song: song),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                // Portada
                                Hero(
                                  tag: song.path,
                                  child: FutureBuilder<Uint8List?>(
                                    future: FileService.loadArtwork(song.path),
                                    builder: (context, snapshot) {
                                      final art = snapshot.data;

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      if (art != null) {
                                        return Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            image: DecorationImage(
                                              image: MemoryImage(art),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }
                                      return Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.music_note,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Título y Artista
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        song.artist,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Descarga / loader / check
                                lrcExists
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 28,
                                      )
                                    : downloadingSongs.contains(song.path)
                                    ? const SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () => downloadOne(song),
                                        icon: const Icon(
                                          Icons.download,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                              ],
                            ),
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
