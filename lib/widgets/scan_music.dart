import 'package:flutter/material.dart';
import 'package:timelyr/screens/scan_screen.dart';
import '../utils/default_music_path.dart';
import 'select_directory.dart';

class ScanMusic extends StatelessWidget {
  const ScanMusic({super.key});

  String get rootPath =>
      SelectDirectory.selectedPath ?? DefaultMusicPath.defaultPath;
  bool onScan(String path, int scannedFiles, int foundSongs) {
    // You can implement any UI update logic here if needed
    return true; // Return true to continue scanning
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0D1B2A),
      title: const Text(
        'Desea  volver a escanear su música?',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.black87,
          ),
          onPressed: () {
            final path = rootPath;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ScanScreen(rootPath: path)),
            );
          },
          child: const Text(
            'Escanear Música',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
