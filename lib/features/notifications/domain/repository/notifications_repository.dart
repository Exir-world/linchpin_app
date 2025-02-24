import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/notifications/domain/entity/notifications_entity.dart';

abstract class NotificationsRepository {
  // لیست اعلانات
  Future<DataState<NotificationsEntity>> notifications();
}
