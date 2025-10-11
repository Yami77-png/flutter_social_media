import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_search_cubit/profile_search_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/friends/application/knot_cubit.dart';
import 'package:flutter_social_media/src/features/notification/application/cubit/notification_cubit.dart';
import 'package:flutter_social_media/src/features/postBind/domain/post_bind_request_args.dart';
import 'package:flutter_social_media/src/features/postBind/presentation/post_bind_request_page.dart';
import '../../../core/helpers/helpers.dart';
import 'empty_notification_page.dart';
import '../../../core/domain/app_notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoadingUserProfile = false;
  _setLoadingUserProfile(bool val) => setState(() => _isLoadingUserProfile = val);

  Future<void> _onProfileTap(String userId) async {
    _setLoadingUserProfile(true);

    try {
      final profileArgs = await context.read<ProfileSearchCubit>().getSearchUserInfo(userId);
      if (profileArgs == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not load user profile.')));
        }
        return;
      }

      // profile page route
      if (mounted) {
        switch (profileArgs.user.userType) {
          case UserType.individual:
            context.pushNamed(
              IndividualProfilePage.route,
              extra: (
                user: profileArgs.user,
                individual: profileArgs.individualProfile,
                business: profileArgs.businessProfile,
                professional: profileArgs.professionalProfile,
                contentCreator: profileArgs.contentCreatorProfile,
              ),
            );
            break;
          case UserType.business:
          case UserType.contentCreator:
          case UserType.professional:
        }
      }
    } catch (e) {
      _setLoadingUserProfile(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      _setLoadingUserProfile(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Please sign in to view notifications')));
    }

    final notifQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        // comment this line while debugging if you suspect createdAt issues
        .orderBy('createdAt', descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: const Text('Notifications')),
            TextButton(
              onPressed: () {
                context.read<NotificationCubit>().markAllAsRead();
              },
              child: Row(children: [Icon(Icons.check), Text('Mark as Read')]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: notifQuery.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Firestore error:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];
              debugPrint('🔔 Fetched ${docs.length} notifications');

              if (docs.isEmpty) {
                return const EmptyNotificationPage();
              }

              final notifications = docs.map((d) {
                final data = d.data();
                data['id'] = data['id'] ?? d.id; // guarantee id
                return AppNotification.fromMap(data);
              }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: notifications.length,
                separatorBuilder: (_, _) => SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final notif = notifications[i];
                  return Dismissible(
                    key: Key(notif.id),
                    onDismissed: (_) {
                      //delete notification
                      notifications.removeAt(i);
                      context.read<NotificationCubit>().deleteNotification(notif.id);
                    },
                    // confirmDismiss: (_) async {
                    //   //TODO: confirm before delete
                    // },
                    background: DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 6,
                            children: [
                              Text('Delete', style: TextStyle(color: Colors.white)),
                              Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    child: ListTile(
                      onTap: () {
                        if (notif.type == NotificationType.knotRequest) {
                          _onProfileTap(notif.payload.userId ?? notif.senderUid);
                        } else if (notif.type == NotificationType.bindPostRequest) {
                          if (notif.payload.postId != null && notif.payload.bindedPostId != null) {
                            context.pushNamed(
                              PostBindRequestPage.route,
                              extra: PostBindRequestPageArgs(
                                postId: notif.payload.postId ?? '',
                                bindedPostId: notif.payload.bindedPostId ?? '',
                                notificationId: notif.id,
                              ),
                            );
                          } else {
                            AppSnackbar.show(context, message: 'Not available');
                          }
                        }

                        context.read<NotificationCubit>().markAsRead(notif.id);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: notif.read ? Colors.transparent : AppColors.primaryColor.withValues(alpha: 0.12),
                      // leading: AppImageViewer(notif.payload.image, isCircle: true, height: 48, width: 48),
                      leading: InkWell(
                        onTap: () {
                          _onProfileTap(notif.payload.userId ?? notif.senderUid);
                        },
                        borderRadius: BorderRadius.circular(99),
                        child: ProfilePicBlob(profilePicUrl: notif.payload.image, size: 48),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              Helpers.getTimeAgo(notif.createdAt.toString()),
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Text(notif.payload.title, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 3),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: notif.payload.body.isNotEmpty,
                            child: Text(
                              notif.payload.body,
                              style: const TextStyle(fontWeight: FontWeight.normal),
                              maxLines: 5,
                            ),
                          ),
                          Visibility(
                            visible:
                                (notif.type.name == NotificationType.knotRequest.name) && notif.payload.body.isEmpty,
                            child: KnotRequestActions(
                              senderUserId: notif.payload.userId ?? notif.senderUid,
                              notificationId: notif.id,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_isLoadingUserProfile)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.33),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class KnotRequestActions extends StatelessWidget {
  final String senderUserId;
  final String notificationId;

  const KnotRequestActions({super.key, required this.senderUserId, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KnotCubit(),
      child: BlocBuilder<KnotCubit, KnotState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildActionButtons(context),
            error: (_) => _buildActionButtons(context),
            loading: () => const SizedBox(height: 36, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
            success: () => _buildConfirmationText('Success!'),
            cancaledRequest: () => _buildConfirmationText('Request Canceled'),
            rejectedRequest: () => _buildConfirmationText('Request Rejected'),
            accepetedRequest: () => _buildConfirmationText('Knot Accepted!'),
            checkingKnot: () => const SizedBox(height: 36),
            hasRequestedKnot: () => _buildConfirmationText('Request Sent'),
            hasIncomingKnot: () => _buildActionButtons(context),
            isKnotted: () => _buildConfirmationText('Already Knotted'),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Take up minimum space
      children: [
        AppButton(
          label: 'Reject',
          isOutlined: true,
          onTap: () {
            context.read<KnotCubit>().rejectKnotRequest(senderUserId);
            context.read<NotificationCubit>().updateNotificationBody(notificationId, 'Request Rejected');
          },
        ),
        const SizedBox(width: 8),
        AppButton(
          label: 'Accept',
          onTap: () {
            context.read<KnotCubit>().acceptKnotRequest(senderUserId);
            context.read<NotificationCubit>().updateNotificationBody(notificationId, 'Request Accepted');
          },
        ),
      ],
    );
  }

  Widget _buildConfirmationText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
      ),
    );
  }
}
