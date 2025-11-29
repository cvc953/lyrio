import 'package:flutter/material.dart';
import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onDownload;

  const SongTile({super.key, required this.song, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Album Art Placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: song.artwork != null
                ? Image.memory(
                    song.artwork!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white70),
                  ),
          ),
          const SizedBox(width: 15),

          // Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Download button
          IconButton(
            onPressed: onDownload,
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
