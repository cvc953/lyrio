import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../services/file_service.dart';
import '../services/lyrics_service.dart';
import '../models/song.dart';
import 'lyrics_viewer.dart';

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

  Future<void> downloadAll() async {
    if (allSongs.isEmpty) return;

    final listToDownload = List<Song>.from(
      filteredSongs.isNotEmpty ? filteredSongs : allSongs,
    );

    setState(() {
      downloadingAll = true;
      progress = 0;
    });

    for (int i = 0; i < listToDownload.length; i++) {
      final song = listToDownload[i];

      setState(() {
        downloadingSongs.add(song.path);
      });

      await LyricsService.downloadAndSave(song);

      setState(() {
        downloadingSongs.remove(song.path);
      });

      setState(() {
        progress = (i + 1) / listToDownload.length;
      });
    }

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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                    borderRadius: BorderRadius.circular(20),
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
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  downloadingAll ? "Descargando..." : "Descargar todas",
                  style: const TextStyle(fontSize: 16),
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
                      itemCount: filteredSongs.length,
                      itemBuilder: (_, i) {
                        final song = filteredSongs[i];
                        final lrcExists = hasLrc(song);

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LyricsViewer(song: song),
                              ),
                            );
                          },
                          leading: Hero(
                            tag: song.path,
                            child: song.artwork != null
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
                              : downloadingSongs.contains(song.path)
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
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
