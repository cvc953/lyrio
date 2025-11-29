import 'package:flutter/material.dart';
import 'package:lyrio/screens/home_screen.dart';
import 'package:metadata_god/metadata_god.dart';

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
      home: const HomeScreen(),
    );
  }
}
