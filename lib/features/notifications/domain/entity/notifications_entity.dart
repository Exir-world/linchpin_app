import 'package:Linchpin/features/notifications/data/models/notifications_model/notification.dart';
import 'package:equatable/equatable.dart';

class NotificationsEntity extends Equatable {
  final List<Notification>? notifications;
  final int? total;

  const NotificationsEntity({this.notifications, this.total});

  @override
  List<Object?> get props => [notifications, total];
}
