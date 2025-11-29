import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import 'library_screen.dart';
import 'lyrics_screen.dart';
import 'search_screen.dart';
import 'more_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
