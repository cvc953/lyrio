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

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'title': title,
      'artist': artist,
      'album': album,
      'durationSeconds': durationSeconds,
      'artwork': artwork != null ? artwork!.toList() : null,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      path: json['path'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      durationSeconds: json['durationSeconds'],
      artwork: json['artwork'] != null
          ? Uint8List.fromList(List<int>.from(json['artwork']))
          : null,
    );
  }
}
