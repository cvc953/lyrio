import 'package:flutter/material.dart';
import 'package:lyrio/screens/main_screen.dart';
import 'package:lyrio/services/file_service.dart';
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
            //FileService.scanMusicWithCallback(rootPath, onScan: onScan);

            Navigator.of(context).pop(false);
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
