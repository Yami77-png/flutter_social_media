import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GridItemThumbnail extends StatefulWidget {
  final XFile file;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  final Uint8List? precomputedThumbnailData;

  const GridItemThumbnail({
    super.key,
    required this.file,
    required this.onRemove,
    required this.onTap,
    this.precomputedThumbnailData,
  });

  @override
  State<GridItemThumbnail> createState() => GridItemThumbnailState();
}

class GridItemThumbnailState extends State<GridItemThumbnail> {
  Uint8List? _thumbnailData;
  bool _isVideo = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.file.path.toLowerCase().endsWith('.mp4');

    if (widget.precomputedThumbnailData != null) {
      _thumbnailData = widget.precomputedThumbnailData;
      _isLoading = false;
    } else if (_isVideo) {
      // _generateThumbnailOnTheFly();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _generateThumbnailOnTheFly() async {
    try {
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: widget.file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );
      if (mounted) {
        setState(() {
          _thumbnailData = thumbnailData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Thumbnail generation failed, using fallback: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildThumbnailContent()),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailContent() {
    if (_isLoading) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    }

    if (_isVideo) {
      if (_thumbnailData != null) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Image.memory(_thumbnailData!, fit: BoxFit.cover),
            const Icon(Icons.play_circle_outline, color: Colors.white70, size: 50),
          ],
        );
      } else {
        return Container(
          color: Colors.grey.shade300,
          child: const Center(child: Icon(Icons.videocam_rounded, color: Colors.white, size: 50)),
        );
      }
    }

    return Image.file(File(widget.file.path), fit: BoxFit.cover);
  }
}
