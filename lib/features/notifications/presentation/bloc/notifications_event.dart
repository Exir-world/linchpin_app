part of 'notifications_bloc.dart';

sealed class NotificationsEvent {}

// لیست اعلانات
class NotificationListEvent extends NotificationsEvent {}

// علامت زدن اعلان
class MarkAsReadEvent extends NotificationsEvent {
  final int notifId;

  MarkAsReadEvent(this.notifId);
}
