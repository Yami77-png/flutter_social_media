import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class FeedAudioPlayer extends StatefulWidget {
  final String url;
  final Color? color;
  final bool isSmall;

  const FeedAudioPlayer({super.key, required this.url, this.isSmall = false, this.color});

  @override
  State<FeedAudioPlayer> createState() => _FeedAudioPlayerState();
}

class _FeedAudioPlayerState extends State<FeedAudioPlayer> {
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
      await _audioPlayer.setUrl(widget.url);
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
    return Row(
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
                icon: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                iconSize: widget.isSmall ? 22 : 30,
                onPressed: _audioPlayer.stop,
              );
            }

            return IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: widget.color ?? AppColors.primaryColor,
                size: widget.isSmall ? 22 : 30,
              ),
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
                        activeColor: widget.color ?? AppColors.primaryColor,
                        inactiveColor: Colors.grey.shade300,
                      );
                    },
                  );
                },
              ),
              if (!widget.isSmall)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Duration>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return Text(
                            _formatDuration(position),
                            style: TextStyle(fontSize: 12.sp, color: widget.color ?? AppColors.primaryColor),
                          );
                        },
                      ),
                      StreamBuilder<Duration?>(
                        stream: _audioPlayer.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data;
                          return Text(
                            _formatDuration(duration),
                            style: TextStyle(fontSize: 12.sp, color: widget.color ?? AppColors.primaryColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
