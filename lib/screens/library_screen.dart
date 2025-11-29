import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../models/song.dart';
import '../services/file_service.dart';
import '../utils/app_storage.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Song> _songs = [];
  bool _loading = true;
  String? _folderPath;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _loading = true);

    // Carpeta que ya guardaste en AppStorage (la misma que usa MainScreen)
    _folderPath = await AppStorage.loadFolder();

    if (_folderPath != null) {
      _songs = await FileService.scanMusic(_folderPath!);
    } else {
      _songs = [];
    }

    setState(() => _loading = false);
  }

  Future<void> _refresh() async {
    await _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Biblioteca",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: _loading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Cargando tus canciones...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                child: _songs.isEmpty
                    ? const Center(
                        child: Text(
                          "No se encontraron canciones",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _songs.length + 1,
                        itemBuilder: (context, index) {
                          // Primera “sección” con el texto "Canciones"
                          if (index == 0) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                "Canciones",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final song = _songs[index - 1];

                          return SongTile(
                            song: song,
                            // En Biblioteca solo mostramos, no descargamos
                            downloading: false,
                            onDownload: () {},
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
