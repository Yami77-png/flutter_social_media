part of 'notification_cubit.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.initial() = _Initial;
  const factory NotificationState.loading() = _Loading;
  const factory NotificationState.loaded({
    required List<AppNotification> notifications,
    required int unreadCount,
    AppNotification? newNotification,
  }) = _Loaded;
  const factory NotificationState.error(String message) = _Error;
}
