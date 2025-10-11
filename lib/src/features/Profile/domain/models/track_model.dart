class Track {
  final String id;
  final String name;
  final List<String> artistNames;
  final String thumbnailUrl;
  final int durationMs;
  final String? previewUrl;

  Track({
    required this.id,
    required this.name,
    required this.artistNames,
    required this.thumbnailUrl,
    required this.durationMs,
    this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    final albumImages = json['album']['images'] as List<dynamic>;
    final imageUrl = albumImages.isNotEmpty ? albumImages[0]['url'] : '';

    return Track(
      id: json['id'],
      name: json['name'],
      artistNames: (json['artists'] as List).map((artist) => artist['name'] as String).toList(),
      thumbnailUrl: imageUrl,
      durationMs: json['duration_ms'],
      previewUrl: json['preview_url'], // can be null
    );
  }

  String get durationFormatted {
    final seconds = (durationMs / 1000).round();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
