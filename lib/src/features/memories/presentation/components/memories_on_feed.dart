import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/services/local_notification_service.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/carousel_media_viewer_page.dart';
import 'package:flutter_social_media/src/features/memories/application/create_memories_cubit/create_memories_cubit.dart';
import 'package:flutter_social_media/src/features/memories/application/fetch_memories_cubit/fetch_memories_cubit.dart';
import 'package:flutter_social_media/src/features/memories/presentation/all_memories_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/components/memory_tile.dart';

class MemoriesOnFeed extends StatelessWidget {
  const MemoriesOnFeed({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateMemoriesCubit, CreateMemoriesState>(
      listener: (context, state) {
        final localNotificationService = LocalNotificationService();

        state.mapOrNull(
          uploading: (uploadingState) async {
            await localNotificationService.showNotification(
              notif: AppNotification(
                id: 'uploading-${DateTime.now().millisecondsSinceEpoch}',
                senderUid: 'self',
                type: NotificationType.postPublished,
                createdAt: DateTime.now(),
                payload: NotificationPayload(title: 'Uploading Memory...', body: uploadingState.message),
              ),
            );
          },
          success: (value) async {
            // TODO append list

            await localNotificationService.showNotification(
              notif: AppNotification(
                id: 'success-${DateTime.now().millisecondsSinceEpoch}',
                senderUid: 'self',
                type: NotificationType.postPublished,
                createdAt: DateTime.now(),
                payload: NotificationPayload(title: 'Audio Published', body: value.message),
              ),
            );

            context.read<CreateMemoriesCubit>().clearState();
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

            context.read<CreateMemoriesCubit>().clearState();
          },
        );
      },
      child: BlocBuilder<FetchMemoriesCubit, FetchMemoriesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            loaded: (memories) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 6.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Memories',
                          style: AppTextStyles.appBarTitle.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(AllMemoriesPage.route, extra: memories);
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 185.h,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: memories.length >= 4 ? 4 : memories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                final List<String> attachments = memories
                                    .map((memory) => memory.attachment?.first ?? '')
                                    .toList();

                                context.pushNamed(
                                  CarouselMediaViewerPage.route,
                                  queryParameters: {'index': index.toString()},
                                  extra: attachments,
                                );
                              },
                              child: MemoryTile(memory: memories[index]),
                            );
                          },
                          separatorBuilder: (_, _) => SizedBox(width: 12.w),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            empty: () => const SizedBox.shrink(),
            error: (message) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
