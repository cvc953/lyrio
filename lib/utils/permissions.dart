import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<bool> requestStorage() async {
    // Android 13+
    final audio = await Permission.audio.request();
    if (audio.isGranted) return true;

    final photos = await Permission.photos.request();
    if (photos.isGranted) return true;

    // Android 12 o menos
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  static Future<bool> requestNotification() async {
    final notification = await Permission.notification.request();
    return notification.isGranted;
  }
}
