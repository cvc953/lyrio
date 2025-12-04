import 'dart:async';
import '../models/song.dart';
import 'lyrics_service.dart';
import '../services/local_notification_service.dart';
import 'notifications_settings.dart';

class DownloadManager {
  DownloadManager._internal();
  static final DownloadManager instance = DownloadManager._internal();
  factory DownloadManager() => instance;

  bool isRunning = false;
  double progress = 0.0;

  final StreamController<double> _progressController =
      StreamController<double>.broadcast();

  Stream<double> get progressStream => _progressController.stream;

  Future<void> downloadAll(List<Song> songs) async {
    if (isRunning) return;

    isRunning = true;

    const notificationId = 1;
    int completed = 0;
    const int poolSize = 3;

    final pending = List<Song>.from(songs);
    final active = <Future>[];

    Future<void> startTask(Song song) async {
      await LyricsService.downloadAndSave(song);
      completed++;
      bool enabled = await NotificationSettings.isEnabled();
      _progressController.add(completed / songs.length);

      if (!enabled) return;

      final notification = LocalNotificationService();
      notification.showNotification(
        id: notificationId,
        progress: completed,
        max: songs.length,
      );
    }

    while (pending.isNotEmpty || active.isNotEmpty) {
      while (pending.isNotEmpty && active.length < poolSize) {
        final song = pending.removeAt(0);
        final task = startTask(song);
        active.add(task);

        task.whenComplete(() {
          active.remove(task);
        });
      }

      await Future.delayed(const Duration(milliseconds: 20));
    }

    //NotificationService.complete(notificationId);

    isRunning = false;
  }
}
