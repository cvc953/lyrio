import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  static const String _key = "notifications_enabled";

  /// Obtener si están activadas (por defecto true)
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  /// Guardar el nuevo estado
  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
