import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/Chat/presentation/about_profile.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/audio_model.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/carousel_media_viewer_page.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/media_viewer_page.dart';
import 'package:flutter_social_media/src/features/feed/presentation/create_audio_page.dart';
import 'package:flutter_social_media/src/features/feed/presentation/sounds_and_podcast_page.dart';
import 'package:flutter_social_media/src/features/friends/presentation/friends_list_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/all_memories_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/create_memory_page.dart';
import 'package:flutter_social_media/src/features/postBind/application/post_bind_cubit/post_bind_cubit.dart';
import 'package:flutter_social_media/src/features/postBind/domain/post_bind_request_args.dart';
import 'package:flutter_social_media/src/features/postBind/presentation/post_bind_request_page.dart';
import 'package:flutter_social_media/src/features/settings/presentation/settings_page.dart';
import 'package:flutter_social_media/src/features/video_editor/presentation/video_editor_page.dart';
import 'package:flutter_social_media/src/sandbox/presentation/sandbox_page.dart';

import '../../features/video_editor/presentation/video_crop_page.dart';

class NavigationService {
  NavigationService._();
  static final instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  void pushNamedIfNotCurrent(String routeName, {Object? extra}) {
    final ctx = context;
    if (ctx != null && ModalRoute.of(ctx)?.settings.name != routeName) {
      ctx.pushNamed(routeName, extra: extra); // ✅ GoRouter push
    }
  }
}

final router = GoRouter(
  navigatorKey: NavigationService.instance.navigatorKey,

  initialLocation: '/',
  routes: [
    //onbording
    GoRoute(name: SplashPage.route, path: '/', builder: (context, state) => SplashPage()),
    GoRoute(name: SandboxPage.route, path: '/${SandboxPage.route}', builder: (context, state) => SandboxPage()),
    // GoRoute(
    //   name: VideoEditorPage.route,
    //   path: '/${VideoEditorPage.route}',
    //   builder: (context, state) => VideoEditorPage(),
    // ),
    // GoRoute(name: SplashPage.route, path: '/', builder: (context, state) => SplashPage()),
    GoRoute(name: GetStarted.route, path: '/${GetStarted.route}', builder: (context, state) => GetStarted()),
    //auth
    GoRoute(name: SigninPage.route, path: '/${SigninPage.route}', builder: (context, state) => SigninPage()),
    GoRoute(
      name: SignUpPage.route,
      path: '/${SignUpPage.route}',
      builder: (context, state) {
        return SignUpPage(userType: state.extra as UserType);
      },
    ),
    GoRoute(
      name: CreateProfilePage.route,
      path: '/${CreateProfilePage.route}',
      builder: (context, state) {
        final record =
            state.extra
                as ({
                  String name,
                  String email,
                  String phoneNumber,
                  String? dob,
                  String? gender,
                  String? ownerName,
                  String? professional,
                  String? designation,
                  UserType userType,
                });

        return CreateProfilePage(
          name: record.name,
          email: record.email,
          phoneNumber: record.phoneNumber,
          dob: record.dob ?? '',
          gender: record.gender ?? 'Male',
          ownerName: record.ownerName ?? '',
          professional: record.professional ?? '',
          designation: record.designation ?? '',
          userType: record.userType,
        );
      },
    ),
    GoRoute(
      name: ResetPasswordPage.route,
      path: '/${ResetPasswordPage.route}',
      builder: (context, state) {
        return ResetPasswordPage();
      },
    ),
    GoRoute(
      name: RestPasswordEmailSuccessPage.route,
      path: '/${RestPasswordEmailSuccessPage.route}',
      builder: (context, state) {
        return RestPasswordEmailSuccessPage();
      },
    ),
    GoRoute(
      name: EmailVerificationPage.route,
      path: '/${EmailVerificationPage.route}',
      builder: (context, state) {
        return EmailVerificationPage();
      },
    ),
    GoRoute(name: FeedPage.route, path: '/${FeedPage.route}', builder: (context, state) => FeedPage()),
    //wrappers
    GoRoute(name: NavWrapperPage.route, path: '/${NavWrapperPage.route}', builder: NavWrapper.routeBuilder),

    // GoRoute(name: ChatroomView.route, path: '/${ChatroomView.route}', builder: (context, state) => ChatroomView()),
    // GoRoute(
    //   name: ChatListPage.route,
    //   path: '/${ChatListPage.route}',
    //   builder: (context, state) => ChatListPage(),),
    // GoRoute(name: ChatroomView.route, path: '/${ChatroomView.route}', builder: (context, state) => ChatroomView()),
    GoRoute(
      name: CreatePostPage.route,
      path: '/${CreatePostPage.route}',
      builder: (context, state) => CreatePostPage(bindedPost: state.extra as Post?),
    ),
    GoRoute(
      name: CreateAudioPage.route,
      path: '/${CreateAudioPage.route}',
      builder: (context, state) => CreateAudioPage(),
    ),
    GoRoute(
      name: PostDetailsPage.route,
      path: '/${PostDetailsPage.route}/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id'];
        final post = state.extra as Post?;

        return PostDetailsPage(post: post, postId: postId);
      },
    ),
    GoRoute(
      name: SelectAccountTypePage.route,
      path: '/${SelectAccountTypePage.route}',
      builder: (context, state) {
        return SelectAccountTypePage();
      },
    ),
    // GoRoute(
    //   name: ProfilePage.route,
    //   path: '/${ProfilePage.route}',
    //   builder: (context, state) {
    //     return ProfilePage();
    //   },
    // ),
    GoRoute(
      name: IndividualProfilePage.route,
      path: '/${IndividualProfilePage.route}',
      builder: (context, state) {
        final record =
            state.extra
                as ({
                  Userx user,
                  IndividualProfileModel? individual,
                  BusinessProfileModel? business,
                  ProfessionalProfileModel? professional,
                  ContentCreatorProfileModel? contentCreator,
                });

        return IndividualProfilePage(
          user: record.user,
          individual: record.individual,
          business: record.business,
          professinal: record.professional,
          contentCreator: record.contentCreator,
        );
      },
    ),
    GoRoute(
      name: FriendsListPage.route,
      path: '/${FriendsListPage.route}',
      builder: (context, state) {
        return FriendsListPage();
      },
    ),
    GoRoute(
      name: ProfileUpdatePage.route,
      path: '/${ProfileUpdatePage.route}',
      builder: (context, state) {
        final record =
            state.extra
                as ({
                  Userx user,
                  IndividualProfileModel? individual,
                  BusinessProfileModel? business,
                  ProfessionalProfileModel? professional,
                  ContentCreatorProfileModel? contentCreator,
                });

        return ProfileUpdatePage(
          user: record.user,
          individual: record.individual,
          business: record.business,
          professinal: record.professional,
          contentCreator: record.contentCreator,
        );
      },
    ),
    //Chat
    GoRoute(
      name: SearchPage.route,
      path: '/${SearchPage.route}',
      builder: (context, state) {
        return SearchPage();
      },
    ),
    GoRoute(
      name: ChatPage.route,
      path: '/${ChatPage.route}',
      builder: (context, state) {
        final record = state.extra as ({String name, String id, String imageUrl, String userId});

        return ChatPage(id: record.id, imageUrl: record.imageUrl, name: record.name, userId: record.userId);
      },
    ),
    GoRoute(
      name: ChatListPage.route,
      path: '/${ChatListPage.route}',
      builder: (context, state) {
        return ChatListPage();
      },
    ),
    GoRoute(
      name: CallScreen.route,
      path: '/${CallScreen.route}',
      builder: (context, state) {
        final record =
            state.extra
                as ({
                  String name,
                  String imageUrl,
                  String callId,
                  bool isCaller,
                  bool isVideoCall,
                  String localId,
                  String remoteId,
                });
        return CallScreen(
          name: record.name,
          imageUrl: record.imageUrl,
          callId: record.callId,
          isCaller: record.isCaller,
          isVideoCall: record.isVideoCall,
          localId: record.localId,
          remoteId: record.remoteId,
        );
      },
    ),
    // <<<<<<< fix/webrtc
    //     // GoRoute(
    //     //   name: WebRTCTestPage.route,
    //     //   path: '/${WebRTCTestPage.route}',
    //     //   builder: (context, state) {
    //     //     final record =
    //     //         state.extra as ({String callId, bool isCaller, bool isVideoCall, String localId, String remoteId});
    //     //     return WebRTCTestPage(
    //     //       callId: record.callId,
    //     //       isCaller: record.isCaller,
    //     //       isVideoCall: record.isVideoCall,
    //     //       localId: record.localId,
    //     //       remoteId: record.remoteId,
    //     //     );
    //     //   },
    //     // ),
    // =======

    // GoRoute(
    //   name: '/',
    //   path: '/',
    //   builder: (context, state) {
    //     return WebRTCTestPage();
    //   },
    // ),
    GoRoute(
      name: AboutProfile.route,
      path: '/${AboutProfile.route}',
      builder: (context, state) {
        final record = state.extra as ({String name, String imageUrl});

        return AboutProfile(name: record.name, imageUrl: record.imageUrl);
      },
    ),
    GoRoute(
      name: VideoCropPage.route,
      path: '/${VideoCropPage.route}',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final videoFile = args?['videoFile'] as File;
        return VideoCropPage(videoFile: videoFile);
      },
    ),
    GoRoute(
      name: VideoEditorPage.route,
      path: '/${VideoEditorPage.route}',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final videoFile = args?['videoFile'] as File;
        return VideoEditorPage(videoFile: videoFile);
      },
    ),
    GoRoute(
      name: SettingsPage.route,
      path: '/${SettingsPage.route}',
      builder: (context, state) {
        return SettingsPage();
      },
    ),
    GoRoute(
      name: SoundsAndPodcastPage.route,
      path: '/${SoundsAndPodcastPage.route}',
      builder: (context, state) {
        return SoundsAndPodcastPage(audios: state.extra as List<AudioModel>);
      },
    ),
    GoRoute(
      name: MediaViewerPage.route,
      path: '/${MediaViewerPage.route}',
      builder: (context, state) {
        final mediaFiles = state.extra as List<XFile>;
        final indexStr = state.uri.queryParameters['index'];
        final initialIndex = int.tryParse(indexStr ?? '0') ?? 0;
        return MediaViewerPage(mediaFiles: mediaFiles, initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: CarouselMediaViewerPage.route,
      name: CarouselMediaViewerPage.route,
      builder: (context, state) {
        final index = int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
        final urls = state.extra as List<String>;
        return CarouselMediaViewerPage(imageUrls: urls, initialIndex: index);
      },
    ),
    GoRoute(
      name: CreateMemoryPage.route,
      path: '/${CreateMemoryPage.route}',
      builder: (context, state) {
        return CreateMemoryPage(imagePath: state.extra as String);
      },
    ),
    GoRoute(
      name: AllMemoriesPage.route,
      path: '/${AllMemoriesPage.route}',
      builder: (context, state) {
        return AllMemoriesPage(memories: state.extra as List<Post>);
      },
    ),
    GoRoute(
      name: PostBindRequestPage.route,
      path: '/${PostBindRequestPage.route}',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => PostBindCubit(),
          child: PostBindRequestPage(args: state.extra as PostBindRequestPageArgs),
        );
      },
    ),
  ],
);
