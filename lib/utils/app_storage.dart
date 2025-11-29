import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const String folderKey = "selected_folder";

  static Future<void> saveFolder(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(folderKey, path);
  }

  static Future<String?> loadFolder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(folderKey);
  }

  static Future<void> clearFolder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(folderKey);
  }
}
