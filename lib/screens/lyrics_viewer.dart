import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/lyrics_service.dart';
import '../services/file_service.dart';

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
          // 💠 Fondo con blur elegante
          Container(
            decoration: BoxDecoration(
              image: widget.song.artwork != null
                  ? DecorationImage(
                      image: MemoryImage(widget.song.artwork!),
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

          // 🎵 Contenido principal
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

                // 🎨 Portada
                Hero(
                  tag: widget.song.path,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: widget.song.artwork != null
                        ? Image.memory(
                            widget.song.artwork!,
                            height: 220,
                            width: 220,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 220,
                            width: 220,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white70,
                              size: 80,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                // 🔽 Botón descagar letra si no existe LRC
                downloading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton.icon(
                        onPressed: lyrics != null
                            ? null
                            : () => downloadLyrics(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text("Descargar letra"),
                      ),

                const SizedBox(height: 15),

                // 📜 Letra
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
