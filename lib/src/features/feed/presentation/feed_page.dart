import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/core/services/local_notification_service.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/features/feed/application/create_post_cubit/create_post_cubit.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/presentation/create_post_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/components/memories_on_feed.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/sounds_and_podcast.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/options_fab.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_actions.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_post_cubit/fetch_post_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/posts_cubit.dart';
import 'package:flutter_social_media/src/features/feed/presentation/post_details_page.dart';
import 'package:flutter_social_media/src/features/postBind/domain/post_bind_request_args.dart';
import '../../feed/presentation/components/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  static String route = 'feed_page';
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // final _player = AudioPlayer();

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<FetchPostCubit>().fetchPost();
  // }

  // Future<void> _init() async {
  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.speech());
  //   _player.errorStream.listen((e) {
  //     print('A stream error occurred: $e');
  //   });
  //   try {
  //     await _player.setAudioSource(
  //       AudioSource.uri(Uri.parse("https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
  //     );
  //   } on PlayerException catch (e) {
  //     log("Error loading audio source: $e");
  //   }
  // }

  _bindPost(Post post) async {
    var currentUserId = await HiveHelper.getCurrentUserId();

    if (post.postedBy.id == currentUserId) {
      AppSnackbar.show(context, message: 'Cannot share own post!');
      return;
    }

    if ((int.tryParse('${post.bindedPostCount}') ?? 0) >= postBindLimit) {
      AppSnackbar.show(context, message: 'Maximum bind limit reached!');
      return;
    }

    if (post.privacy == PostPrivacy.ONLYME) {
      AppSnackbar.show(context, message: 'Cannot bind this post!');
      return;
    }

    context.pushNamed(CreatePostPage.route, extra: post);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<FetchPostCubit>().fetchPost();
        },
        child: BlocListener<CreatePostCubit, CreatePostState>(
          listener: (context, state) async {
            final localNotificationService = LocalNotificationService();

            state.mapOrNull(
              uploading: (uploadingState) async {
                await localNotificationService.showNotification(
                  notif: AppNotification(
                    id: 'uploading-${DateTime.now().millisecondsSinceEpoch}',
                    senderUid: 'self',
                    type: NotificationType.postPublished,
                    createdAt: DateTime.now(),
                    payload: NotificationPayload(title: 'Uploading Post...', body: uploadingState.message),
                  ),
                );
              },
              success: (successState) async {
                final newPost = successState.post;

                if (newPost?.bindedPost?.privacy != PostPrivacy.PUBLIC) {
                  context.read<CreatePostCubit>().clearState();
                  return;
                }

                // Append the new post to the list
                context.read<PostsCubit>().addPostAtTop(newPost!);

                await localNotificationService.showNotification(
                  notif: AppNotification(
                    id: 'success-${DateTime.now().millisecondsSinceEpoch}',
                    senderUid: 'self',
                    type: NotificationType.postPublished,
                    createdAt: DateTime.now(),
                    payload: NotificationPayload(title: 'Post Published', body: successState.message),
                  ),
                );

                // Reset the cubit's state to be ready for the next post
                context.read<CreatePostCubit>().clearState();
              },
              error: (errorState) async {
                await localNotificationService.showNotification(
                  notif: AppNotification(
                    id: 'error-${DateTime.now().millisecondsSinceEpoch}',
                    senderUid: 'self',
                    type: NotificationType.postPublished,
                    createdAt: DateTime.now(),
                    payload: NotificationPayload(title: 'Post Failed', body: errorState.message),
                  ),
                );

                // Also reset the state on error
                context.read<CreatePostCubit>().clearState();
              },
            );
          },
          child: Scaffold(
            floatingActionButton: OptionsFAB(),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                spacing: 14,
                children: [
                  MemoriesOnFeed(),
                  SoundsAndPodcast(),
                  BlocConsumer<FetchPostCubit, FetchPostState>(
                    listener: (context, state) {
                      state.map(
                        loading: (_) {},
                        loaded: (s) {
                          context.read<PostsCubit>().setPosts(s.posts);
                        },
                        error: (_) {},
                      );
                    },
                    builder: (context, state) {
                      return state.map(
                        loading: (_) => const Center(child: CircularProgressIndicator()),
                        error: (_) => const Center(child: Text("Something went wrong")),
                        loaded: (_) {
                          return BlocBuilder<PostsCubit, Map<String, Post>>(
                            builder: (context, state) {
                              var data = state.values.toList();
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.pushNamed(
                                              PostDetailsPage.route,
                                              pathParameters: {'id': data[index].id},
                                              extra: data[index],
                                            );
                                          },
                                          child: PostCard(post: data[index], key: ValueKey(data[index].id)),
                                        ),
                                        PostActions(
                                          postId: data[index].id,
                                          onBindingTap:
                                              //hide bind button for already binded post
                                              data[index].bindedPostId != null ? null : () => _bindPost(data[index]),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
