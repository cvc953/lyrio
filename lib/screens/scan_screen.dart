import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../utils/default_music_path.dart';
import 'main_screen.dart';
import '../widgets/gradient_background.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String currentPath = "";
  int scannedFiles = 0;
  int foundSongs = 0;
  bool done = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  Future<void> startScan() async {
    final path = DefaultMusicPath.defaultPath;

    await FileService.scanMusicWithCallback(
      path,
      onScan: (path, scanned, songs) {
        setState(() {
          currentPath = path;
          scannedFiles = scanned;
          foundSongs = songs;
        });
      },
    );

    if (!mounted) return;

    setState(() => done = true);

    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Color(0xFF0D1B2A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              Text(
                "Escaneando archivos...",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                "Escaneados: $scannedFiles",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Canciones encontradas: $foundSongs",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Text(
                currentPath,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
