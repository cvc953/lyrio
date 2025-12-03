import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lyrio/screens/search_screen.dart';
import 'package:lyrio/utils/artwork_cache.dart';
import '../models/song.dart';
import '../services/lyrics_service.dart';
import 'dart:typed_data';

class LyricsViewer extends StatefulWidget {
  final Song song;

  const LyricsViewer({super.key, required this.song});

  @override
  State<LyricsViewer> createState() => _LyricsViewerState();
}

class _LyricsViewerState extends State<LyricsViewer> {
  String? lyrics;
  bool loading = true;
  bool downloading = false;
  Uint8List? artwork;
  bool noLyricsFound = false;

  @override
  void initState() {
    super.initState();
    loadLyrics();
  }

  Future<void> loadLyrics() async {
    // Ver si ya existe archivo LRC
    final file = File(widget.song.path);
    final base = file.uri.pathSegments.last.split('.').first;
    final lrcPath = "${file.parent.path}/$base.lrc";

    if (File(lrcPath).existsSync()) {
      lyrics = await File(lrcPath).readAsString();
      setState(() => loading = false);
      return;
    }

    // Si no existe → intentar descargar
    final result = await LyricsService.fetchLyrics(widget.song);

    lyrics = result;
    setState(() => loading = false);
  }

  Future<void> downloadLyrics() async {
    setState(() => downloading = true);

    final ok = await LyricsService.downloadAndSave(widget.song);

    if (ok) {
      await loadLyrics();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Letra descargada.")));
    } else {
      setState(() => noLyricsFound = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No se encontró letra.")));
    }

    setState(() => downloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con blur
          Container(
            decoration: BoxDecoration(
              image: artwork != null
                  ? DecorationImage(
                      image: MemoryImage(artwork!),
                      fit: BoxFit.cover,
                      opacity: 0.35,
                    )
                  : null,
              gradient: const LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Flecha atrás
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Hero(
                  tag: widget.song.path,
                  child: FutureBuilder<Uint8List?>(
                    future: ArtworkCache.load(widget.song.path),
                    builder: (context, snapshot) {
                      final art = snapshot.data;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }
                      if (art != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            art,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white70,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // Titulo
                Text(
                  widget.song.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Artista
                Text(
                  widget.song.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                Text(
                  widget.song.album,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white54),
                ),
                Text(
                  "${widget.song.durationSeconds ~/ 60}:${(widget.song.durationSeconds % 60).toString().padLeft(2, '0')} min",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white54),
                ),

                const SizedBox(height: 15),

                // Botón descagar letra si no existe LRC
                downloading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : noLyricsFound
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchScreen(
                                initialTitle: widget.song.title,
                                initialAlbum: widget.song.album,
                                initialArtist: widget.song.artist,
                              ),
                            ),
                          );
                          if (result != null) {
                            await LyricsService.saveManualResult(
                              widget.song,
                              result,
                            );
                            await loadLyrics();
                          }
                        },
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text(
                          "Buscar letra manualmente",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => downloadLyrics(),
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          "Descargar letra",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),

                const SizedBox(height: 15),

                // Letra
                Expanded(
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : lyrics == null
                      ? const Center(
                          child: Text(
                            "No hay letra disponible",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            lyrics!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
