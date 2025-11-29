import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class Song {
  final String path;
  final String title;
  final String artist;
  final String album;
  final int durationSeconds;
  final Uint8List? artwork;

  Song({
    required this.path,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationSeconds,
    required this.artwork,
  });
}
