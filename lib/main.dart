import 'package:flutter/material.dart';
import 'package:lyrio/screens/home_screen.dart';
import 'package:metadata_god/metadata_god.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MetadataGod.initialize(); // 🔥 obligatorio

  runApp(const HomeScreen());
}
