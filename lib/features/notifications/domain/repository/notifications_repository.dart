import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/success_entity.dart';
import 'package:linchpin/features/notifications/domain/entity/notifications_entity.dart';

abstract class NotificationsRepository {
  // لیست اعلانات
  Future<DataState<NotificationsEntity>> notifications();

  // علامت زدن اعلان
  Future<DataState<SuccessEntity>> markAsRead(int notifId);
  // وضعیت موقعیت مکانی
  Future<DataState<SuccessEntity>> statusLocation();
}
