import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';

class SelectedMedia {
  final String url;
  final double aspectRatio;
  final CommentType type;

  SelectedMedia({required this.url, required this.aspectRatio, this.type = CommentType.gif});
}
