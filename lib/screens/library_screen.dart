import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../services/file_service.dart';
import '../models/song.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    songs = FileService.librarySongs;
    setState(() {}); // refresca cuando regresas desde otra pestaña
  }

  bool hasLrc(Song song) {
    final file = File(song.path);
    final dir = file.parent.path;
    final base = file.uri.pathSegments.last.split('.').first;
    final lrcPath = '$dir/$base.lrc';
    return File(lrcPath).existsSync();
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
        body: songs.isEmpty
            ? const Center(
                child: Text(
                  "No hay canciones.\nVe a la pestaña Letras para escanear.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (_, i) {
                  final song = songs[i];
                  final lrcDownloaded = hasLrc(song);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),

                    // ---------- CARÁTULA ----------
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

                    // ---------- TÍTULO + ARTISTA ----------
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

                    // ---------- INDICADOR LRC ----------
                    trailing: Icon(
                      lrcDownloaded
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: lrcDownloaded
                          ? Colors.greenAccent
                          : Colors.white30,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
