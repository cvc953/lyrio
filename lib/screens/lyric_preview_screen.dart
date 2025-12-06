import 'package:flutter/material.dart';
import 'package:timelyr/models/lyric_result.dart';
import 'package:timelyr/services/file_service.dart';

class LyricPreviewScreen extends StatelessWidget {
  final LyricResult result;
  final String? savePath; // ruta del archivo .lrc de la canción original

  const LyricPreviewScreen({super.key, required this.result, this.savePath});

  @override
  Widget build(BuildContext context) {
    final lyrics = result.syncedLyrics.isNotEmpty
        ? result.syncedLyrics
        : result.plainLyrics;

    String formatDuration(double seconds) {
      final int total = seconds.floor();
      final int minutes = total ~/ 60;
      final int remaining = total % 60;

      return "$minutes:${remaining.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(result.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INFO DE LA CANCIÓN
              Text(
                result.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${result.artist} • ${result.album} • ${formatDuration(result.durationSeconds)} min",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // LETRA
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: result.isInstrumental != true
                    ? Text(
                        lyrics,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    : Text(
                        "Esta canción es instrumental y no contiene letra.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),

              //if (result.isInstrumental == true)
              const SizedBox(height: 30),
              // BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Seleccionar esta letra
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, result);
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Usar esta letra",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),

                  if (savePath != null)
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FileService.saveLRC(savePath!, lyrics);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Letra guardada como archivo .lrc"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Guardar"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
