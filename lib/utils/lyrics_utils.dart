bool isSynced(String lyrics) {
  final regex = RegExp(r'\[\d{2}:\d{2}(?:\.\d{2,3})?\]');
  return regex.hasMatch(lyrics);
}

String pickBestLyrics(String synced, String plain) {
  synced = synced.trim();
  plain = plain.trim();

  final regex = RegExp(r'\[\d{2}:\d{2}(?:\.\d{2,3})?\]');

  if (synced.isNotEmpty && regex.hasMatch(synced)) {
    return synced; // 🔥 Preferir la sincronizada
  }

  return plain; // fallback
}
