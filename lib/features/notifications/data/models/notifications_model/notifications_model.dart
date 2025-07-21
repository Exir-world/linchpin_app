import 'package:linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:flutter/foundation.dart';
import 'notification.dart';

@immutable
class NotificationsModel extends NotificationsEntity {
  const NotificationsModel({super.notifications, super.total});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'notifications': notifications?.map((e) => e.toJson()).toList(),
        'total': total,
      };
}
