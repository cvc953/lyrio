import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<bool> requestStorage() async {
    // Android 13+
    final audio = await Permission.audio.request();
    if (audio.isGranted) return true;

    // Android 11+: MANAGE_EXTERNAL_STORAGE
    final manage = await Permission.manageExternalStorage.request();
    if (manage.isGranted) return true;

    // Android < 10
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }
}
