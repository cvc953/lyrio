import 'package:flutter/material.dart';
import 'package:lyrio/utils/app_storage.dart';
import 'package:lyrio/utils/permissions.dart';
import '../widgets/gradient_background.dart';
import 'scan_screen.dart';
import '../utils/default_music_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Color(0xFF0D1B2A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lyrics_rounded, size: 120, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "Lyrio",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Encuentra letras sincronizadas\npara toda tu música",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text("Comenzar"),
                onPressed: () async {
                  final granted = await AppPermissions.requestStorage();
                  if (!granted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Se requieren permisos de almacenamiento para continuar.",
                        ),
                      ),
                    );
                    return;
                  }

                  await AppStorage.setFirstRunFalse();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ScanScreen(rootPath: DefaultMusicPath.defaultPath),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
