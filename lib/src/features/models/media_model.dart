
enum MediaType {
  image,
  video,
  reel,
  audio
}

class MediaModel {
  final String url;
  final MediaType mediaType;
  final double aspectRatioValue;
  final String? thumbnailUrl; // For video preview
  final Duration? duration; // For video/reel duration

  const MediaModel({
    required this.url,
    required this.mediaType,
    required this.aspectRatioValue,
    this.thumbnailUrl,
    this.duration,
  });
  }

