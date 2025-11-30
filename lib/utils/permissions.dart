import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<bool> requestStorage() async {
    // Android 13+
    final audio = await Permission.mediaLibrary.request();
    if (audio.isGranted) return true;

    final photos = await Permission.photos.request();
    if (photos.isGranted) return true;

    final videos = await Permission.videos.request();
    if (videos.isGranted) return true;

    // Android 12 o menos
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }
}
