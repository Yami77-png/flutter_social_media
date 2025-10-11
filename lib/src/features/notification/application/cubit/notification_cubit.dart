import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/domain/app_notification.dart';
import 'package:flutter_social_media/src/core/services/local_notification_service.dart';
import 'package:flutter_social_media/src/features/notification/infrastructure/notification_repository.dart';
import 'package:rxdart/rxdart.dart';
part 'notification_state.dart';
part 'notification_cubit.freezed.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;
  final LocalNotificationService _localNotificationService;
  StreamSubscription? _notificationSubscription;

  NotificationCubit(this._notificationRepository, this._localNotificationService)
    : super(const NotificationState.initial());

  void startListening() {
    log('NotificationCubit: Starting to listen for notifications...');
    if (state is! _Loaded) {
      emit(const NotificationState.loading());
    }

    _notificationSubscription?.cancel();

    _notificationRepository.getNotificationsStream().pairwise().listen(
      (notificationLists) {
        final previousList = notificationLists.first;
        final newList = notificationLists.last;

        final unreadCount = newList.where((n) => !n.read).length;

        // Check if a new, unread notification has been added at the top
        if (newList.isNotEmpty && (previousList.isEmpty || newList.first.id != previousList.first.id)) {
          final newNotification = newList.first;
          if (!newNotification.read) {
            log('New notification detected: ${newNotification.id}');
            // Emit a SINGLE 'loaded' state that contains the new notification info.
            emit(
              NotificationState.loaded(
                notifications: newList,
                unreadCount: unreadCount,
                newNotification: newNotification,
              ),
            );
            return; // Exit after emitting
          }
        }
      },
      onError: (error) {
        log('Error in notification stream: $error');
        emit(NotificationState.error(error.toString()));
      },
    );
  }

  // Method to trigger the local notification display
  void showInAppNotification(AppNotification notif) {
    _localNotificationService.showNotification(notif: notif);
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
    } catch (e) {
      log('Failed to delete notification from cubit: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationRepository.markAllAsRead();
    } catch (e) {
      log('Failed to delete notification from cubit: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
    } catch (e) {
      log('Failed to delete notification from cubit: $e');
    }
  }

  Future<void> updateNotificationBody(String notificationId, String body) async {
    try {
      await _notificationRepository.updateNotificationBody(notificationId, body);
    } catch (e) {
      log('Failed to delete notification from cubit: $e');
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
