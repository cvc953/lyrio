class LyricResult {
  final int id;
  final String plainLyrics;
  final String syncedLyrics;
  final String title;
  final String artist;
  final String album;
  final double durationSeconds;

  LyricResult({
    required this.id,
    required this.plainLyrics,
    required this.syncedLyrics,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationSeconds,
  });

  factory LyricResult.fromJson(Map<String, dynamic> json) {
    return LyricResult(
      id: json["id"] ?? 0,
      plainLyrics: json["plainLyrics"] ?? "",
      syncedLyrics: json["syncedLyrics"] ?? "",
      title: json["trackName"] ?? "",
      artist: json["artistName"] ?? "",
      album: json["albumName"] ?? "",
      durationSeconds: (json["duration"] ?? 0).toDouble(),
    );
  }
}
