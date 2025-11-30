import 'package:flutter/material.dart';
import 'package:lyrio/screens/home_screen.dart';
import 'package:metadata_god/metadata_god.dart';
import 'utils/app_storage.dart';
import 'widgets/gradient_background.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MetadataGod.initialize(); // 🔥 obligatorio

  runApp(const MyApp()); // <-- vuelve tu estructura original
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        future: AppStorage.isFirstRun(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const GradientBackground(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }

          final firstRun = snapshot.data as bool;

          if (firstRun) {
            return const HomeScreen(); // 👈 bienvenida
          }

          return const MainScreen(); // 👈 app normal
        },
      ),
    );
  }
}
