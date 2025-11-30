import 'package:flutter/material.dart';
import 'package:lyrio/screens/main_screen.dart';
import 'package:lyrio/utils/app_storage.dart';
import 'package:lyrio/utils/permissions.dart';
import '../widgets/gradient_background.dart';
import 'scan_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  }
                  await AppStorage.setFirstRunFalse();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
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
