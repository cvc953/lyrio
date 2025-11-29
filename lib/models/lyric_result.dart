class LyricResult {
  final String plainLyrics;
  final String syncedLyrics;

  LyricResult({required this.plainLyrics, required this.syncedLyrics});

  factory LyricResult.fromJson(Map<String, dynamic> json) {
    return LyricResult(
      plainLyrics: json["plainLyrics"] ?? "",
      syncedLyrics: json["syncedLyrics"] ?? "",
    );
  }
}
