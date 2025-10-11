import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/injection.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/helpers/app_config.dart';
import 'package:flutter_social_media/src/core/router/router_config.dart';
import 'package:flutter_social_media/src/core/services/local_notification_service.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/connectivity_cubit.dart';
import 'package:flutter_social_media/src/core/utility/secrets.dart';
import 'package:flutter_social_media/src/features/Chat/application/call_cubit.dart';
import 'package:flutter_social_media/src/features/Chat/application/fetch_chat_rooms_cubit/fetch_chat_room_list_cubit.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_cubit.dart';
import 'package:flutter_social_media/src/features/Locale/application/locale_state.dart';
import 'package:flutter_social_media/src/features/Locale/infrastructure/locale_repository.dart';
import 'package:flutter_social_media/src/features/Profile/application/location_cubit/location_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_search_cubit/profile_search_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/send_knot_request_cubit/knot_request_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/infrastructure/location_repository.dart';
import 'package:flutter_social_media/src/features/Profile/infrastructure/user_repository.dart';
import 'package:flutter_social_media/src/features/auth/application/auth_status_cubit/auth_status_cubit.dart';
import 'package:flutter_social_media/src/features/auth/application/obscure_text_cubit/obscure_text_cubit.dart';
import 'package:flutter_social_media/src/features/auth/application/rest_password_cubit/rest_password_cubit.dart';
import 'package:flutter_social_media/src/features/auth/application/sign_in_cubit/sign_in_cubit.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/application/create_audio_cubit/create_audio_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/create_post_cubit/create_post_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_audios_cubit/fetch_audios_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_post_comments/fetch_post_comments_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_user_post_cubit/fetch_user_post_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/like_comment_cubit/like_comment_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/like_cubit/like_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/profile_pic_cubit/profile_pic_cubit.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/audio_repository.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_post_cubit/fetch_post_cubit.dart';
import 'package:flutter_social_media/src/features/auth/application/sign_up_cubit/sign_up_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/posts_cubit.dart';
import 'package:flutter_social_media/src/features/friends/application/knots_list_cubit/knots_list_cubit.dart';
import 'package:flutter_social_media/src/features/friends/infrustructure/knots_list_repository.dart';
import 'package:flutter_social_media/src/features/memories/application/create_memories_cubit/create_memories_cubit.dart';
import 'package:flutter_social_media/src/features/memories/application/fetch_memories_cubit/fetch_memories_cubit.dart';
import 'package:flutter_social_media/src/features/notification/application/cubit/notification_cubit.dart';
import 'package:flutter_social_media/src/features/notification/infrastructure/notification_repository.dart';
import 'package:flutter_social_media/src/features/settings/application/profile_pic_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/application/screenshot_privacy_cubit.dart';
import 'package:flutter_social_media/src/features/settings/infrastructure/settings_repository.dart';
import 'package:flutter_social_media/src/features/thread_videos/applications/bloc/videos_bloc.dart';
import 'package:upgrader/upgrader.dart';

final localNotificationService = LocalNotificationService();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // late BuildContext _appContext;

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final LocationRepository locationRepository = LocationRepository(Secrets.googleCloudPlacesApiKey, firestore);
    // _appContext = context;
    return MultiBlocProvider(
      providers: [
        //auth
        BlocProvider(create: (context) => AuthStatusCubit(AuthRepository())),
        BlocProvider(create: (context) => SignUpCubit(AuthRepository())),
        BlocProvider(create: (context) => SignInCubit(AuthRepository())),
        BlocProvider(create: (context) => RestPasswordCubit(AuthRepository())),
        //feed
        BlocProvider(create: (context) => getIt<FetchPostCubit>()),
        BlocProvider(create: (context) => FetchPostCommentsCubit()),
        BlocProvider(create: (context) => LikeCubit(FeedRepository(), AuthRepository())),
        BlocProvider(create: (context) => LikeCommentCubit()),
        BlocProvider(create: (context) => CreatePostCubit(FeedRepository())),
        BlocProvider(create: (context) => CreateAudioCubit(AudioRepository(FeedRepository()))),
        BlocProvider(create: (context) => FetchAudiosCubit(AudioRepository(FeedRepository()))),
        BlocProvider(create: (context) => getIt<CreateMemoriesCubit>()),
        BlocProvider(create: (context) => getIt<FetchMemoriesCubit>()),
        //user
        BlocProvider(create: (context) => ProfileCubit(AuthRepository()), lazy: false),
        BlocProvider(create: (context) => ProfileSearchCubit(AuthRepository())),
        BlocProvider(create: (context) => FetchUserPostsCubit(FeedRepository())),
        //chat
        BlocProvider(create: (context) => FetchChatRoomListCubit()),
        BlocProvider(create: (context) => CallCubit()),
        //check internet connection
        BlocProvider(create: (context) => ConnectivityCubit()),
        // Profile Picture
        BlocProvider(create: (context) => ProfilePicCubit(AuthRepository())),
        BlocProvider(create: (context) => PostsCubit({})),
        // profile page location select
        BlocProvider(create: (context) => LocationCubit(locationRepository)),
        BlocProvider(create: (context) => VideosBloc()),
        BlocProvider(create: (context) => KnotRequestCubit(UserRepository())),
        BlocProvider(create: (context) => KnotsListCubit(KnotsListRepository())),
        // notification
        BlocProvider(create: (context) => NotificationCubit(NotificationRepository(), localNotificationService)),
        // Locale
        BlocProvider(create: (context) => LocaleCubit(LocaleRepository())),
        // Obscure Password
        BlocProvider(create: (context) => ObscureTextCubit()),
        // Settings
        BlocProvider(create: (context) => ProfilePicPrivacyCubit(SettingsRepository(), AuthRepository())),
        BlocProvider(create: (context) => ScreenshotPrivacyCubit(SettingsRepository())),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          Locale? appLocale;

          if (state is LocaleLoadSuccess) {
            appLocale = Locale(state.locale.languageCode, state.locale.countryCode);
          }

          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: AppConfig.instance.appName,
                locale: appLocale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: ThemeData(
                  colorSchemeSeed: AppColors.primaryColor,
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                  progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.primaryColor),
                ),
                routerConfig: router,
                builder: (context, child) {
                  return _networkListener(
                    UpgradeAlert(
                      upgrader: Upgrader(debugLogging: true, minAppVersion: '0.1.1'),
                      child: child!,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  _networkListener(Widget? child) {
    return BlocListener<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state == ConnectivityStatus.disconnected) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('No internet connection'),
              backgroundColor: Colors.redAccent,
              duration: Duration(days: 1),
            ),
          );
        } else if (state == ConnectivityStatus.connected) {
          messenger.hideCurrentSnackBar();
        }
      },
      child: child,
    );
  }
}
