import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'library_screen.dart';
import 'lyrics_screen.dart';
import 'search_screen.dart';
import 'more_screen.dart';
import 'welcome_screen.dart';
import '../utils/default_music_path.dart';
import '../utils/app_storage.dart';
import '../services/file_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    LibraryScreen(),
    LyricsScreen(),
    SearchScreen(),
    MoreScreen(),
  ];

  bool _loading = true;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final firstRun = await AppStorage.isFirstRun();

    if (firstRun) {
      setState(() => _showWelcome = true);
    } else {
      await _initializeLibrary();
    }
  }

  Future<void> _initializeLibrary() async {
    String? folder = await AppStorage.loadFolder();

    if (folder == null) {
      folder = DefaultMusicPath.defaultPath;
      await AppStorage.saveFolder(folder);
    }

    // Escaneo automático
    await FileService.scanMusic(folder);

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // PANTALLA DE BIENVENIDA
    if (_showWelcome) {
      return WelcomeScreen(
        onStart: () async {
          await AppStorage.setFirstRunFalse();
          await _initializeLibrary();
          setState(() => _showWelcome = false);
        },
      );
    }

    // PANTALLA DE CARGA
    if (_loading) {
      return const GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "Escaneando tu música...",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // PANTALLA NORMAL
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: const Color(0xFF0D1B2A),
          indicatorColor: Colors.blueAccent.withOpacity(0.25),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            setState(() => _currentIndex = i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.library_music_outlined),
              selectedIcon: Icon(Icons.library_music),
              label: "Biblioteca",
            ),
            NavigationDestination(
              icon: Icon(Icons.lyrics_outlined),
              selectedIcon: Icon(Icons.lyrics),
              label: "Letras",
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search_rounded),
              label: "Buscar",
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              selectedIcon: Icon(Icons.more),
              label: "Más",
            ),
          ],
        ),
      ),
    );
  }
}
