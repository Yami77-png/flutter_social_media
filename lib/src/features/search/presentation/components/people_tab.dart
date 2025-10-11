import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/profile_picture_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/Chat/infrastructure/chat_service.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_search_cubit/profile_search_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';

class PeopleTab extends StatelessWidget {
  const PeopleTab({required this.stream, required this.term});
  final Stream<QuerySnapshot> stream;
  final String term;

  @override
  Widget build(BuildContext context) {
    if (term.isEmpty) {
      return const Center(child: Text('Start typing to search...'));
    }
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final user = users[i];
            final String name = user['name'] as String;
            final String uuid = user['uuid'] as String;
            final String userType = user['userType'] as String;

            return FutureBuilder<String?>(
              future: ProfilePictureHelper().getProfilePictureUrl(
                uuid,
                fallbackToPublicAvatarIfNull: userType == 'individual',
              ),
              builder: (context, snapshot) {
                final String? photoUrl = snapshot.data;

                return ListTile(
                  leading: ProfilePicBlob(profilePicUrl: photoUrl, size: 40),
                  title: Text(name),
                  trailing: TextButton(
                    onPressed: () async {
                      final roomId = await ChatService().createRoom(uuid); // returns room id
                      context.pushNamed(
                        ChatPage.route,
                        extra: (name: name, id: roomId, imageUrl: photoUrl, userId: uuid),
                      );
                    },
                    child: const Text('Chat'),
                  ),
                  onTap: () => context.read<ProfileSearchCubit>().getSearchUserInfo(uuid), // open profile
                );
              },
            );
          },
        );
      },
    );
  }
}
