import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/audio_player_with_details.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/feed_audio_player.dart';

class SoundsAndPodcastPage extends StatefulWidget {
  static String route = "sound_podcast_page";
  const SoundsAndPodcastPage({super.key, required this.audios});

  final List<AudioModel> audios;

  @override
  State<SoundsAndPodcastPage> createState() => _SoundsAndPodcastPageState();
}

class _SoundsAndPodcastPageState extends State<SoundsAndPodcastPage> {
  AudioModel? _selectedAudio;

  @override
  void initState() {
    setState(() {
      _selectedAudio = widget.audios.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Sounds and Podcast'),
      body: Column(
        children: [
          _buildMainPlayer(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.audios.length,
              itemBuilder: (context, index) {
                final audio = widget.audios[index];
                return _buildAudioTile(audio, isSelected: _selectedAudio?.id == audio.id);
              },
              separatorBuilder: (_, _) => const SizedBox(height: 8),
            ),
          ),
        ],
      ),
      // body: BlocConsumer<FetchAudiosCubit, FetchAudiosState>(
      //   listener: (context, state) {
      //     state.mapOrNull(
      //       loaded: (loadedState) {
      //         if (_selectedAudio == null && loadedState.audios.isNotEmpty) {
      //           setState(() {
      //             _selectedAudio = loadedState.audios.first;
      //           });
      //         }
      //       },
      //     );
      //   },
      //   builder: (context, state) {
      //     return state.when(
      //       initial: () => const SizedBox.shrink(),
      //       loading: () => const Center(child: CircularProgressIndicator()),
      //       loaded: (audios) {
      //         return Column(
      //           children: [
      //             _buildMainPlayer(),
      //             Expanded(
      //               child: ListView.builder(
      //                 padding: const EdgeInsets.all(16.0),
      //                 itemCount: audios.length,
      //                 itemBuilder: (context, index) {
      //                   final audio = audios[index];
      //                   return _buildAudioTile(audio, isSelected: _selectedAudio?.id == audio.id);
      //                 },
      //               ),
      //             ),
      //           ],
      //         );
      //       },
      //       empty: () => const Center(child: Text("No audios have been posted yet.")),
      //       error: (message) => Center(child: Text(message)),
      //     );
      //   },
      // ),
    );
  }

  bool showAudioControls = true;
  toggleShowAudioControls() {
    setState(() {
      showAudioControls = !showAudioControls;
    });
  }

  Widget _buildMainPlayer() {
    if (_selectedAudio == null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.8)),
        child: Center(
          child: Text('Select an audio to play', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return GestureDetector(
      onTap: toggleShowAudioControls,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black87),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImageViewer(
              _selectedAudio!.coverImageUrl,
              fit: BoxFit.cover,
              darken: showAudioControls ? 0.25 : 0,
              errorWidget: Container(color: Colors.grey.shade800),
            ),
            AnimatedOpacity(
              duration: Durations.medium1,
              opacity: showAudioControls ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Durations.medium1,
              opacity: showAudioControls ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedAudio!.title,
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'by ${_selectedAudio!.artist}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14.sp),
                    ),
                    const SizedBox(height: 10),
                    FeedAudioPlayer(
                      key: ValueKey(_selectedAudio!.id),
                      url: _selectedAudio!.audioUrl,
                      isSmall: false,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioTile(AudioModel audio, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAudio = audio;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.15) : Color(0xFFE6F4FC),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: AudioPlayerWithDetails(audio: audio, isMinimal: true),
        ),
      ),
    );
  }
}
