import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AppLocalAudioPlayer extends StatefulWidget {
  final File? file;

  const AppLocalAudioPlayer({super.key, this.file});

  @override
  State<AppLocalAudioPlayer> createState() => _AppLocalAudioPlayerState();
}

class _AppLocalAudioPlayerState extends State<AppLocalAudioPlayer> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.file != null) {
      _setAudioSource();
    }
  }

  @override
  void didUpdateWidget(covariant AppLocalAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file?.path != oldWidget.file?.path) {
      if (widget.file != null) {
        _setAudioSource();
      } else {
        _audioPlayer.stop();
      }
    }
  }

  Future<void> _setAudioSource() async {
    try {
      await _audioPlayer.setFilePath(widget.file!.path);
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// mm:ss.
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.file == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          // play/Pause Button
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final isPlaying = playerState?.playing ?? false;

              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return const SizedBox(width: 40.0, height: 40.0, child: CircularProgressIndicator());
              }

              return IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, size: 40, color: AppColors.primaryColor),
                onPressed: () {
                  if (isPlaying) {
                    _audioPlayer.pause();
                  } else if (processingState != ProcessingState.completed) {
                    _audioPlayer.play();
                  } else {
                    _audioPlayer.seek(Duration.zero);
                    _audioPlayer.play();
                  }
                },
              );
            },
          ),
          // audio timer
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration?>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (context, positionSnapshot) {
                        var position = positionSnapshot.data ?? Duration.zero;
                        // Ensure position doesn't exceed duration
                        if (position > duration) {
                          position = duration;
                        }
                        return Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final newPosition = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(newPosition);
                          },
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey.shade400,
                        );
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Duration>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return Text(_formatDuration(position), style: TextStyle(fontSize: 12.sp));
                        },
                      ),
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return Text(_formatDuration(duration), style: TextStyle(fontSize: 12.sp));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
