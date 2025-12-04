import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationService() {
    _initialize();
  }

  void _initialize() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification({
    required int id,
    required int progress,
    required int max,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel_id',
          'Default Channel',
          channelDescription: 'This is the default notification channel',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      progress < max ? 'Descargando...' : 'Descarga Completada',
      max > 0 ? 'Progress: $progress / $max' : null,
      notificationDetails,
    );
  }
}
