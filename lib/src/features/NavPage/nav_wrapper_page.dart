import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Profile/menu_page.dart';
import 'package:flutter_social_media/src/features/notification/application/cubit/notification_cubit.dart';
import 'package:flutter_social_media/src/features/notification/presentation/notification_page.dart';
import 'package:flutter_social_media/src/features/thread_videos/presentations/videos_page.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void navigateTo(int pageIndex) => emit(pageIndex);
  void reset() => emit(0);
}

class NavWrapper {
  static Widget routeBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider(create: (context) => NavigationCubit(), child: const NavWrapperPage());
  }
}

class NavWrapperPage extends StatefulWidget {
  const NavWrapperPage({super.key});
  static String route = 'nav_wrapper_page';

  @override
  State<NavWrapperPage> createState() => _NavWrapperPageState();
}

class _NavWrapperPageState extends State<NavWrapperPage> {
  final List<int> _tabHistory = [0];

  final List<IconData> selectedItem = const [Icons.home, Icons.video_collection, Icons.notifications, Icons.menu];

  final List<IconData> unselectedItem = const [
    Icons.home_outlined,
    Icons.video_collection_outlined,
    Icons.notifications_none_outlined,
    Icons.menu_outlined,
  ];

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().startListening();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listenWhen: (prev, curr) => curr.maybeMap(loaded: (s) => s.newNotification != null, orElse: () => false),
      listener: (context, state) {
        state.mapOrNull(
          loaded: (s) {
            if (s.newNotification != null) {
              context.read<NotificationCubit>().showInAppNotification(s.newNotification!);
            }
          },
        );
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          if (_tabHistory.length > 1) {
            _tabHistory.removeLast();
            context.read<NavigationCubit>().navigateTo(_tabHistory.last);
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Flutter Social Media",
              style: TextStyle(color: AppColors.primaryColor, fontFamily: 'Poppins'),
            ),
            actions: [
              IconButton(onPressed: () => context.pushNamed(SearchPage.route), icon: const Icon(Icons.search)),
              IconButton(onPressed: () => context.pushNamed(ChatListPage.route), icon: Icon(Icons.chat_outlined)),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                height: 52,
                child: BlocBuilder<NavigationCubit, int>(
                  builder: (context, currentIndex) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(selectedItem.length, (index) {
                        final isSelected = currentIndex == index;
                        final iconData = isSelected ? selectedItem[index] : unselectedItem[index];

                        return GestureDetector(
                          onTap: () {
                            if (_tabHistory.isEmpty || _tabHistory.last != index) {
                              _tabHistory.add(index);
                            }
                            context.read<NavigationCubit>().navigateTo(index);
                          },
                          child:
                              index ==
                                  2 // Notifications tab
                              ? BlocBuilder<NotificationCubit, NotificationState>(
                                  builder: (context, notifState) {
                                    final unread = notifState.mapOrNull(loaded: (s) => s.unreadCount) ?? 0;
                                    return Badge(
                                      isLabelVisible: unread > 0,
                                      label: Text('$unread'),
                                      backgroundColor: AppColors.primaryColor,
                                      child: Icon(iconData),
                                    );
                                  },
                                )
                              : Icon(iconData),
                        );
                      }),
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<NavigationCubit, int>(
                  builder: (context, index) {
                    return IndexedStack(
                      index: index,
                      children: const [FeedPage(), VideosPage(), NotificationPage(), MenuPage()],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
