class LyricResult {
  final String lyrics;
  final String syncedLyrics;

  LyricResult({required this.lyrics, required this.syncedLyrics});

  factory LyricResult.fromJson(Map<String, dynamic> json) {
    return LyricResult(
      lyrics: json["plainLyrics"] ?? "",
      syncedLyrics: json["syncedLyrics"] ?? "",
    );
  }
}
