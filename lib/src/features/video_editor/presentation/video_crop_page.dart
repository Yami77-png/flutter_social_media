import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';

class VideoCropPage extends StatefulWidget {
  static const route = 'video_crop_page';
  final File videoFile;

  const VideoCropPage({super.key, required this.videoFile});

  @override
  State<VideoCropPage> createState() => _VideoCropPageState();
}

class _VideoCropPageState extends State<VideoCropPage> {
  late final VideoEditorController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(
      widget.videoFile,
      minDuration: const Duration(seconds: 0),
      maxDuration: const Duration(minutes: 10),
    );

    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await _controller.initialize();

      // Start with 16:9 crop area selected
      _controller.preferredCropAspectRatio = 16 / 9;

      if (!mounted) return;
      setState(() => _initialized = true);
    } catch (e) {
      debugPrint('VideoEditorController init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load video. Please try another.')));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File?> _exportCroppedVideo() async {
    final minCrop = _controller.cacheMinCrop;
    final maxCrop = _controller.cacheMaxCrop;

    final cropWidth = (maxCrop.dx - minCrop.dx) * _controller.videoWidth;
    final cropHeight = (maxCrop.dy - minCrop.dy) * _controller.videoHeight;
    final cropX = minCrop.dx * _controller.videoWidth;
    final cropY = minCrop.dy * _controller.videoHeight;

    final cropFilter = 'crop=$cropWidth:$cropHeight:$cropX:$cropY';

    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_cropped.mp4';

    final inputPath = widget.videoFile.path;

    final command = '-y -i "$inputPath" -vf "$cropFilter" -preset ultrafast -c:a copy "$outputPath"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      final croppedFile = File(outputPath);
      if (await croppedFile.exists()) return croppedFile;
    }
    return null;
  }

  void _onCropDone() async {
    final croppedFile = await _exportCroppedVideo();
    if (croppedFile != null && mounted) {
      Navigator.pop(context, {'video': croppedFile});
    } else {
      // fallback, return original if crop failed
      Navigator.pop(context, {'video': widget.videoFile});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Crop Video',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Crop Editor
            Expanded(
              child: CropGridViewer.edit(controller: _controller, margin: const EdgeInsets.all(16)),
            ),

            // Aspect Ratio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildAspectButton("16:9", 16 / 9), _buildAspectButton("9:16", 9 / 16)],
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _onCropDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectButton(String label, double ratio) {
    final isSelected = _controller.preferredCropAspectRatio == ratio;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _controller.preferredCropAspectRatio = ratio;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Colors.grey[800],
          foregroundColor: isSelected ? Colors.black : Colors.white,
        ),
        child: Text(label),
      ),
    );
  }
}
