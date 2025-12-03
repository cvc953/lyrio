import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ArtworkCache {
  static late String cacheDir;

  static Future<void> init() async {
    // Esto devuelve: /storage/emulated/0/Android/data/com.example.lyrio/files/
    final Directory? extDir = await getExternalStorageDirectory();

    if (extDir == null) {
      print("ERROR: getExternalStorageDirectory() devolvió null");
      return;
    }

    final Directory dir = Directory(p.join(extDir.path, "artcache"));

    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print(">>> Creado: ${dir.path}");
    } else {
      print(">>> Ya existe: ${dir.path}");
    }

    cacheDir = dir.path;
  }

  static String key(String songPath) {
    return base64Url.encode(utf8.encode(songPath)).replaceAll("=", "") + ".png";
  }

  static Future<void> save(String path, Uint8List data) async {
    final file = File(p.join(cacheDir, key(path)));
    await file.writeAsBytes(data, flush: true);
  }

  static Future<Uint8List?> load(String path) async {
    final file = File(p.join(cacheDir, key(path)));
    return file.existsSync() ? await file.readAsBytes() : null;
  }
}
