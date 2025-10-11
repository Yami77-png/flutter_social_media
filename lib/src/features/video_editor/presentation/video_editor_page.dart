import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';

class VideoEditorPage extends StatefulWidget {
  static const String route = 'video_editor_page';

  const VideoEditorPage({super.key, required this.videoFile});

  final File videoFile;

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  late final VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(widget.videoFile, maxDuration: const Duration(minutes: 10))
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Exports processed video -> FFmpeg command.
  Future<Map<String, File>?> _exportVideoAndCover() async {
    _isExporting.value = true;

    final start = _controller.startTrim.inMilliseconds / 1000;
    final end = _controller.endTrim.inMilliseconds / 1000;
    final duration = end - start;

    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid trim selection')));
      _isExporting.value = false;
      return null;
    }

    final coverData = _controller.selectedCoverVal;
    final coverTimeOriginal = (coverData?.timeMs ?? _controller.startTrim.inMilliseconds) / 1000;
    final coverTime = (coverTimeOriginal - start).clamp(0, duration); // relative to trimmed video

    final tempDir = await getTemporaryDirectory();
    final epoch = DateTime.now().millisecondsSinceEpoch;
    final videoPath = '${tempDir.path}/${epoch}_trimmed.mp4';
    final thumbPath = '${tempDir.path}/${epoch}_thumbnail.jpg';

    // FFmpeg rotation filter
    String rotationFilter = "";
    final rotation = _controller.rotation;
    if (rotation == 90) {
      rotationFilter = 'transpose=1';
    } else if (rotation == 180) {
      rotationFilter = 'transpose=1,transpose=1';
    } else if (rotation == 270) {
      rotationFilter = 'transpose=2';
    }

    // Build ffmpeg command as a single string
    String trimCommand = '-y -ss $start -t $duration -i "${widget.videoFile.path}" ';

    if (rotationFilter.isNotEmpty) {
      trimCommand += '-vf $rotationFilter ';
    }

    trimCommand += '-c:v libx264 -preset ultrafast -c:a aac "$videoPath"';

    final trimSession = await FFmpegKit.execute(trimCommand);
    final trimCode = await trimSession.getReturnCode();

    if (!ReturnCode.isSuccess(trimCode)) {
      final logs = await trimSession.getAllLogsAsString();
      debugPrint("Video trim failed. Logs: $logs");
      _isExporting.value = false;
      return null;
    }

    // Thumbnail command
    final thumbCommand = '-y -ss $coverTime -i "$videoPath" -vframes 1 "$thumbPath"';

    final thumbSession = await FFmpegKit.execute(thumbCommand);
    final thumbCode = await thumbSession.getReturnCode();

    _isExporting.value = false;

    if (ReturnCode.isSuccess(thumbCode)) {
      final videoFile = File(videoPath);
      final thumbFile = File(thumbPath);

      if (await videoFile.exists() && await thumbFile.exists()) {
        return {'video': videoFile, 'thumbnail': thumbFile};
      } else {
        debugPrint("Success code, but output files missing.");
      }
    } else {
      final logs = await thumbSession.getAllLogsAsString();
      debugPrint("Thumbnail extraction failed. Logs: $logs");
    }

    return null;
  }

  void _processExport() async {
    final result = await _exportVideoAndCover();

    if (!mounted) return;

    if (result != null) {
      // export succeed
      context.pop(result);
    } else {
      // Export failed
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to export. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _topNavBar(),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CropGridViewer.preview(controller: _controller),
                                        AnimatedBuilder(
                                          animation: _controller.video,
                                          builder: (_, __) => Opacity(
                                            opacity: _controller.isPlaying ? 0 : 1,
                                            child: GestureDetector(
                                              onTap: _controller.video.play,
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.play_arrow, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CoverViewer(controller: _controller),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    const TabBar(
                                      tabs: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(padding: EdgeInsets.all(5), child: Icon(Icons.content_cut)),
                                            Text('Trim'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(padding: EdgeInsets.all(5), child: Icon(Icons.video_label)),
                                            Text('Cover'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          Column(mainAxisAlignment: MainAxisAlignment.center, children: _trimSlider()),
                                          _coverSelection(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isExporting,
                    builder: (_, bool exporting, __) => exporting
                        ? Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text("Exporting video...", style: TextStyle(fontSize: 16.sp)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.exit_to_app),
                tooltip: 'Leave editor',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(
                onPressed: () => _controller.rotate90Degrees(RotateDirection.left),
                icon: Icon(Icons.rotate_left),
                tooltip: 'Rotate left',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => _controller.rotate90Degrees(RotateDirection.right),
                icon: Icon(Icons.rotate_right),
                tooltip: 'Rotate right',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(onPressed: _processExport, icon: const Icon(Icons.check), tooltip: 'Export video'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([_controller, _controller.video]),
        builder: (_, __) {
          final duration = _controller.videoDuration.inSeconds;
          final pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(
              children: [
                Text(formatter(Duration(seconds: pos.toInt()))),
                const Expanded(child: SizedBox()),
                Opacity(opacity: _controller.isTrimming ? 1 : 0, child: Text(formatter(_controller.trimmedDuration))),
              ],
            ),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(controller: _controller, padding: const EdgeInsets.only(top: 10)),
        ),
      ),
    ];
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
  ].join(":");

  Widget _coverSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: height / 4),
      child: CoverSelection(controller: _controller, quantity: 8),
    );
  }
}
