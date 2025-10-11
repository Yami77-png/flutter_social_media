import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/helpers/profile_picture_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/Chat/application/fetch_chat_rooms_cubit/fetch_chat_room_list_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  static const String route = 'chat_list_page';
  @override
  Widget build(BuildContext context) {
    context.read<FetchChatRoomListCubit>().getChatList();

    return Scaffold(
      appBar: AppAppBar(title: 'Message'),
      // appBar: AppBar(title: Text("Messages"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<FetchChatRoomListCubit, FetchChatRoomListState>(
          builder: (context, state) {
            return state.map(
              loading: (_) {
                return Center(child: CircularProgressIndicator.adaptive());
              },
              loaded: (value) {
                return ListView.separated(
                  itemCount: value.chats.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    var chat = value.chats[index];
                    final otherUserId = chat.userId;

                    if (otherUserId == null) {
                      return const SizedBox.shrink();
                    }
                    return FutureBuilder<String?>(
                      future: ProfilePictureHelper().getProfilePictureUrl(otherUserId),
                      builder: (context, snapshot) {
                        final profilePicUrl = snapshot.data;
                        return GestureDetector(
                          onTap: () async {
                            if (chat.userId == null) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("User doesn't exist!")));
                              return;
                            }

                            final String imageUrl =
                                await ProfilePictureHelper().getProfilePictureUrl(chat.userId!) ?? "";

                            context.pushNamed(
                              ChatPage.route,
                              extra: (name: chat.otherUserName, id: chat.id, imageUrl: imageUrl, userId: chat.userId),
                            );
                          },

                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.5, color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ProfilePicBlob(profilePicUrl: profilePicUrl, size: 50),
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chat.otherUserName ?? 'Unknown User',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            chat.lastMessage ?? 'No message yet!',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.normal,
                                              // color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.right,
                                      Helpers.getTimeAgo(value.chats[index].createdAt!.toDate().toString()),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (_) {
                return Center(child: Text("No chat found"));
              },
            );
          },
        ),
      ),
    );
  }
}
