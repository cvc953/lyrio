import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import '../utils/artwork_cache.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        const path = "/storage/emulated/0/Music/TUPRIMERA-CANCION.flac";

        print(">>> TEST: Leyendo metadata…");

        final metadata = await MetadataGod.readMetadata(file: path);

        print(">>> metadata.picture = ${metadata.picture}");
        print(
          ">>> metadata.picture?.data length = ${metadata.picture?.data.length}",
        );

        if (metadata.picture?.data != null) {
          await ArtworkCache.load(path);
          print(">>> GUARDADO en cache");
        } else {
          print(">>> NO HAY COVER");
        }
      },
      child: Text("Test Artwork"),
    );
  }
}
