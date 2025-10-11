import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/grid_item_thumbnail.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/media_viewer_page.dart';

class MediaGridPreview extends StatelessWidget {
  final List<XFile> mediaFiles;
  final Function(int) onRemove;
  final Map<String, Uint8List> videoThumbnails;

  const MediaGridPreview({super.key, required this.mediaFiles, required this.onRemove, required this.videoThumbnails});

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) {
      return const SizedBox.shrink();
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        final file = mediaFiles[index];
        final precomputedThumbnail = videoThumbnails[file.path];

        return GridItemThumbnail(
          file: file,
          precomputedThumbnailData: precomputedThumbnail,
          onRemove: () => onRemove(index),
          onTap: () {
            context.pushNamed(MediaViewerPage.route, queryParameters: {'index': index.toString()}, extra: mediaFiles);
          },
        );
      },
    );
  }
}
