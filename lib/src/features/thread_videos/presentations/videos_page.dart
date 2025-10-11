import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/features/thread_videos/applications/bloc/videos_bloc.dart';
import 'package:flutter_social_media/src/features/thread_videos/presentations/video_player_page.dart';

import 'video_card.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<VideosBloc>().add(const VideosEvent.fetchVideos());
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BlocBuilder<VideosBloc, VideosState>(
              builder: (context, state) {
                return state.maybeMap(
                  videosLoading: (_) => CircularProgressIndicator.adaptive(),
                  videosLoaded: (state) {
                    return GridView.builder(
                      // padding: const EdgeInsets.all(16),
                      // itemCount: state.videos.length,
                      // separatorBuilder: (_, __) => const SizedBox(height: 16),
                      // padding: const EdgeInsets.all(16),
                      // The total number of items in the grid.
                      itemCount: state.videos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        var video = state.videos[index];
                        return VideoCard(
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerPage(
                                  videoUrl: video.videoUrl,
                                  description: video.description,
                                  postedByAvatar: video.postedBy.imageUrl,
                                  postedByName: video.postedBy.name,
                                  timeAgo: Helpers.getTimeAgo(video.uploadedAt.toString()),
                                  title: video.title,
                                  views: video.viewCount.toString(),
                                  id: video.id,
                                ),
                              ),
                            );
                          },
                          thumbnailUrl: video.thumbnailUrl,
                          avatarUrl: video.postedBy.imageUrl,
                          title: video.postedBy.name,
                          timeAgo: Helpers.getTimeAgo("${video.uploadedAt}", isShort: true),
                          description: video.description,
                          views: video.viewCount.toString(),
                        );
                      },
                    );
                  },

                  orElse: () => SizedBox.shrink(), // fallback widget
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
