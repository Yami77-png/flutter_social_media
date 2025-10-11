import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioPlayer extends StatefulWidget {
  final String sourceUrl;
  final bool isSender;

  const AppAudioPlayer({super.key, required this.sourceUrl, required this.isSender});

  @override
  State<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    // Listen to player state
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.sourceUrl);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? d) {
    if (d == null) return "00:00";
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSender ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: MediaQuery.sizeOf(context).width * 0.65,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final isPlaying = playerState?.playing ?? false;

              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return IconButton(
                  icon: const CircularProgressIndicator(strokeWidth: 2),
                  iconSize: 30,
                  onPressed: _audioPlayer.stop,
                );
              }

              return IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle, color: color, size: 30),
                onPressed: () {
                  if (isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                },
              );
            },
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<Duration?>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, durationSnapshot) {
                    final duration = durationSnapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (context, positionSnapshot) {
                        var position = positionSnapshot.data ?? Duration.zero;
                        if (position > duration) {
                          position = duration;
                        }
                        return Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.round()));
                          },
                          activeColor: color,
                          inactiveColor: color.withValues(alpha: 0.3),
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
                          return Text(_formatDuration(position), style: TextStyle(fontSize: 12.sp, color: color));
                        },
                      ),
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data;
                          return Text(_formatDuration(duration), style: TextStyle(fontSize: 12.sp, color: color));
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
