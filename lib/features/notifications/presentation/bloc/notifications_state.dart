part of 'notifications_bloc.dart';

sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

// لیست اعلانات
final class NotificationListLoadingState extends NotificationsState {}

final class NotificationListCompletedState extends NotificationsState {
  final NotificationsEntity notificationsEntity;

  NotificationListCompletedState(this.notificationsEntity);
}

final class NotificationListErrorState extends NotificationsState {
  final String errorText;

  NotificationListErrorState(this.errorText);
}

// علامت زدن اعلان
final class MarkAsReadLoadingState extends NotificationsState {}

final class MarkAsReadCompletedState extends NotificationsState {
  final SuccessEntity successEntity;

  MarkAsReadCompletedState(this.successEntity);
}

final class MarkAsReadErrorState extends NotificationsState {
  final String errorText;

  MarkAsReadErrorState(this.errorText);
}
