import 'package:flutter/material.dart';
import 'package:lyrio/models/lyric_result.dart';
import 'package:lyrio/services/lrclib_service.dart';
import 'package:lyrio/widgets/gradient_background.dart';
import 'lyric_preview_screen.dart';

class SearchScreen extends StatefulWidget {
  final String initialTitle;
  final String initialArtist;
  final String initialAlbum;
  const SearchScreen({
    super.key,
    this.initialTitle = "",
    this.initialArtist = "",
    this.initialAlbum = "",
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController artistController = TextEditingController();

  bool isSearching = false;
  String? _lyric;
  String? _error;
  List<LyricResult> results = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle;
    albumController.text = widget.initialAlbum;
    artistController.text = widget.initialArtist;
  }

  @override
  void dispose() {
    titleController.dispose();
    albumController.dispose();
    artistController.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    final title = titleController.text.trim();
    final artist = artistController.text.trim();
    final album = albumController.text.trim();

    if (title.isEmpty && artist.isEmpty && album.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingrese al menos un campo para buscar."),
        ),
      );
      return;
    }
    setState(() {
      isSearching = true;
      results = [];
      _error = null;
    });

    final list = await LRCLibService.getManualLyrics(
      artist: artist,
      title: title,
      album: album,
    );

    if (!mounted) return;

    setState(() {
      isSearching = false;

      if (list.isEmpty) {
        _error = "No se encontraron letras para los criterios dados.";
      } else {
        results = list;
      }
    });
  }

  String formatDuration(double seconds) {
    final int total = seconds.floor();
    final int minutes = total ~/ 60;
    final int remaining = total % 60;

    return "$minutes:${remaining.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Color(0xFF0D1B2A),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Busqueda Manual",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        body: ListView(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Titulo",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  prefixIcon: const Icon(Icons.music_note, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: TextField(
                controller: artistController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Artista",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: TextField(
                controller: albumController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Album",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  prefixIcon: const Icon(Icons.album, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: isSearching ? null : _onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isSearching
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Buscar",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (!isSearching && results.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, i) {
                  final item = results[i];

                  return Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      title: Text(
                        item.title.isNotEmpty ? item.title : "Sin título",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${item.artist} • ${item.album.isNotEmpty ? item.album : 'Sin álbum'} • ${formatDuration(item.durationSeconds)}",

                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        final selected = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LyricPreviewScreen(
                              result: item,
                              savePath: null,
                            ),
                          ),
                        );
                        if (selected != null) {
                          Navigator.pop(context, selected);
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
