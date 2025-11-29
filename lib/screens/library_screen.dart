import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'scan_screen.dart';
import '../models/song.dart';
import '../services/file_service.dart';
import '../utils/app_storage.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.15),
          elevation: 0,
          title: const Text(
            "Biblioteca",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
        ),
        body: const _LibraryContent(),
      ),
    );
  }
}

class _LibraryContent extends StatefulWidget {
  const _LibraryContent();

  @override
  State<_LibraryContent> createState() => _LibraryContentState();
}

class _LibraryContentState extends State<_LibraryContent> {
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final folderPath = await AppStorage.loadFolder();

    if (folderPath == null) {
      setState(() => songs = []);
      return;
    }

    final result = await FileService.scanMusic(folderPath);
    setState(() => songs = result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 110.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Canciones",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),

          ...songs.map((song) => _SongTile(song: song)).toList(),
        ],
      ),
    );
  }
}

class _SongTile extends StatelessWidget {
  final Song song;

  const _SongTile({required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.artwork != null
            ? Image.memory(
                song.artwork!,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              )
            : Container(
                width: 55,
                height: 55,
                color: Colors.white12,
                child: const Icon(Icons.music_note, color: Colors.white54),
              ),
      ),
      title: Text(
        song.title.trim().isNotEmpty ? song.title : song.path.split("/").last,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        song.artist.trim().isNotEmpty ? song.artist : "Artista desconocido",
        style: const TextStyle(color: Colors.white54, fontSize: 15),
      ),
      trailing: Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.7)),
      onTap: () {
        // abrir pantalla reproductor próximamente
      },
    );
  }
}
