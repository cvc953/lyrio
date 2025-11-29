import 'package:flutter/material.dart';
import 'package:lyrio/utils/app_storage.dart';
import '../utils/folder_picker.dart';
import '../services/file_service.dart';
import '../services/lrclib_service.dart';
import '../utils/permissions.dart';
import '../models/song.dart';

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

  @override
  void initState() {
    super.initState();
    loadSavedFolder();
  }

  Future<void> loadSavedFolder() async {
    final saved = await AppStorage.loadFolder();
    if (saved != null) {
      setState(() => folderPath = saved);
    }
  }

  Future<void> pickFolder() async {
    final path = await FolderPicker.pickFolder();
    if (path != null) {
      setState(() => folderPath = path);

      //Guardar la ruta seleccionada
      await AppStorage.saveFolder(path);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Carpeta seleccionada:\n$path")));
    }
  }

  Future<void> scan() async {
    if (folderPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona una carpeta primero")),
      );
      return;
    }

    setState(() => loading = true);

    if (!await AppPermissions.requestStorage()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permisos rechazados")));
      setState(() => loading = false);
      return;
    }

    songs = await FileService.scanMusic(folderPath!);
    setState(() => loading = false);
  }

  Future<void> downloadSingle(Song song) async {
    final result = await LRCLibService.getLyrics(
      artist: song.artist,
      title: song.title,
      album: song.album,
      durationSeconds: song.durationSeconds,
    );
    if (result != null) {
      await FileService.saveLRC(song.path, result.syncedLyrics);
    }
  }

  /// ===============================
  /// 🔥 Descargar TODAS las letras
  /// ===============================
  Future<void> downloadAllLyrics() async {
    if (songs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay canciones escaneadas")),
      );
      return;
    }

    setState(() {
      downloadingAll = true;
      progress = 0;
    });

    int total = songs.length;
    int done = 0;

    for (final song in songs) {
      try {
        await downloadSingle(song);
      } catch (_) {}

      done++;
      setState(() => progress = done / total);
    }

    setState(() => downloadingAll = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Descarga completa ✔")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear canciones")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickFolder,
            child: const Text("Seleccionar carpeta"),
          ),
          if (folderPath != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Carpeta seleccionada:\n$folderPath",
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(onPressed: scan, child: const Text("Escanear")),

          // =============================
          // 🔥 BOTÓN DESCARGAR TODAS
          // =============================
          if (songs.isNotEmpty && !downloadingAll)
            ElevatedButton.icon(
              onPressed: downloadAllLyrics,
              icon: const Icon(Icons.download),
              label: const Text("Descargar todas las letras"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),

          // =============================
          // 🔵 Barra de progreso
          // =============================
          if (downloadingAll)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text("Descargando letras..."),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 8),
                  Text("${(progress * 100).toStringAsFixed(0)} %"),
                ],
              ),
            ),

          // =============================
          // 📄 Lista de canciones
          // =============================
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (_, i) {
                      final s = songs[i];
                      return ListTile(
                        title: Text(s.title),
                        subtitle: Text(s.path),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => downloadSingle(s),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
