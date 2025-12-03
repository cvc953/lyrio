class Song {
  final String path;
  final String title;
  final String artist;
  final String album;
  final int durationSeconds;

  Song({
    required this.path,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'title': title,
      'artist': artist,
      'album': album,
      'durationSeconds': durationSeconds,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      path: json['path'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      durationSeconds: json['durationSeconds'],
    );
  }
}
