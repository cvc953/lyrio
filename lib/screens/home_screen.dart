import 'package:flutter/material.dart';
import 'scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LRC Downloader")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Escanear y descargar letras"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanScreen()),
            );
          },
        ),
      ),
    );
  }
}
