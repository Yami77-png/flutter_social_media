


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/media_model.dart';

class AudioPlayerWidget extends StatefulWidget {
  final MediaModel media;

  const AudioPlayerWidget({super.key, required this.media});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.media.url).then((_) {
      setState(() => _isLoading = false);
    }).catchError((e) {
      debugPrint('Audio load error: $e');
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return


      SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 60,
            ),
            onPressed: _togglePlayPause,
          ),
        ),
      ),
    );




  }
}
