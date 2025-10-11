import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_action.dart';

class AudioPlayerWithDetails extends StatefulWidget {
  final AudioModel audio;
  final bool isMinimal;

  const AudioPlayerWithDetails({super.key, required this.audio, this.isMinimal = false});

  @override
  State<AudioPlayerWithDetails> createState() => _FeedAudioPlayerState();
}

class _FeedAudioPlayerState extends State<AudioPlayerWithDetails> {
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
      await _audioPlayer.setUrl(widget.audio.audioUrl);
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

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final isPlaying = playerState?.playing ?? false;

            return Stack(
              children: [
                CircleAvatar(
                  radius: widget.isMinimal ? 36.r : 46.r,
                  backgroundImage: widget.audio.coverImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(widget.audio.coverImageUrl)
                      : null, // set null if no image
                  child: widget.audio.coverImageUrl.isEmpty ? const Icon(Icons.error_outline_rounded) : null,
                ),
                if (!widget.isMinimal)
                  GestureDetector(
                    onTap: () {
                      if (isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                    child: CircleAvatar(
                      radius: widget.isMinimal ? 34 : 46.r,
                      backgroundColor: Colors.black.withValues(alpha: 0.20),
                      child: Visibility(
                        visible:
                            !(processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering),
                        replacement: IconButton(
                          icon: const CircularProgressIndicator(color: Colors.white),
                          iconSize: 30,
                          onPressed: _audioPlayer.stop,
                        ),
                        child: Container(
                          height: 30.r,
                          width: 30.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 0.75, color: Colors.white),
                          ),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow_outlined, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.audio.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.appBarTitle.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                widget.audio.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.appBarTitle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 6),
              if (!widget.isMinimal)
                Row(
                  spacing: 6.w,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: StreamBuilder<Duration?>(
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
                              return SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 18,
                                  //thumbShape: SliderComponentShape.noThumb
                                ),
                                child: Slider(
                                  padding: EdgeInsets.zero,
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    _audioPlayer.seek(Duration(seconds: value.round()));
                                  },
                                  activeColor: AppColors.primaryColor,
                                  inactiveColor: Colors.grey.shade300,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _buildReact(),
                    _buildComment(),
                  ],
                ),
            ],
          ),
        ),
        if (widget.isMinimal) ...[_buildReact(), _buildComment()],
      ],
    );
  }

  PostAction _buildComment() => PostAction(actionIcon: Icons.mode_comment_outlined, count: '');

  PostAction _buildReact() => PostAction(actionIcon: Icons.arrow_upward_rounded, count: '');
}
