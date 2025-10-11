import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/services/local_notification_service.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/feed/application/create_audio_cubit/create_audio_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/audio_player_with_details.dart';
import 'package:flutter_social_media/src/features/feed/presentation/sounds_and_podcast_page.dart';
import '../../application/fetch_audios_cubit/fetch_audios_cubit.dart';

class SoundsAndPodcast extends StatelessWidget {
  const SoundsAndPodcast({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAudioCubit, CreateAudioState>(
      listener: (context, state) {
        final localNotificationService = LocalNotificationService();

        state.mapOrNull(
          success: (value) async {
            // TODO append audio list

            await localNotificationService.showNotification(
              notif: AppNotification(
                id: 'success-${DateTime.now().millisecondsSinceEpoch}',
                senderUid: 'self',
                type: NotificationType.postPublished,
                createdAt: DateTime.now(),
                payload: NotificationPayload(title: 'Audio Published', body: value.message),
              ),
            );

            context.read<CreateAudioCubit>().clearState();
          },
          error: (value) async {
            await localNotificationService.showNotification(
              notif: AppNotification(
                id: 'error-${DateTime.now().millisecondsSinceEpoch}',
                senderUid: 'self',
                type: NotificationType.postPublished,
                createdAt: DateTime.now(),
                payload: NotificationPayload(title: 'Audio upload Failed', body: value.message),
              ),
            );

            context.read<CreateAudioCubit>().clearState();
          },
        );
      },
      child: BlocBuilder<FetchAudiosCubit, FetchAudiosState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            loaded: (audios) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sounds and Podcast',
                          style: AppTextStyles.appBarTitle.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(SoundsAndPodcastPage.route, extra: audios);
                          },
                          child: Text(
                            'See More',
                            style: AppTextStyles.appBarTitle.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: audios.length >= 2 ? 2 : audios.length,
                      itemBuilder: (context, index) {
                        final audio = audios[index];
                        return _buildAudioTile(audio);
                      },
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    ),
                  ],
                ),
              );
            },
            empty: () => const SizedBox.shrink(),
            error: (message) => const SizedBox.shrink(),
            // empty: () => const Center(child: Text("No audios have been posted yet.")),
            // error: (message) => Center(child: Text(message)),
          );
        },
      ),
    );
  }

  DecoratedBox _buildAudioTile(AudioModel audio) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Color(0xFFE6F4FC), borderRadius: BorderRadius.circular(22.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: AudioPlayerWithDetails(audio: audio),
      ),
    );
  }
}
