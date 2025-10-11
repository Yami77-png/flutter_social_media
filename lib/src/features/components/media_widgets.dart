import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/components/audio_player_widget.dart';
import 'package:flutter_social_media/src/features/components/video_display_widget.dart';
import '../models/media_model.dart';
import 'image_display_widget.dart';

class MediaDisplayWidget extends StatelessWidget {
  final MediaModel media;

  const MediaDisplayWidget({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    switch (media.mediaType) {
      case MediaType.image:
        return ImageDisplayWidget(media: media);
      case MediaType.video:
      case MediaType.reel:
        return VideoDisplayWidget(media: media);
      case MediaType.audio:
        return AudioPlayerWidget(media: media);
    }
  }
}
