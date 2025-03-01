import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/success_entity.dart';
import 'package:linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:linchpin/features/notifications/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationsUsecase {
  final NotificationsRepository notificationsRepository;

  NotificationsUsecase(this.notificationsRepository);

  // لیست اعلانات
  Future<DataState<NotificationsEntity>> notifications();

  // علامت زدن اعلان
  Future<DataState<SuccessEntity>> markAsRead(int notifId);
}

@Singleton(as: NotificationsUsecase, env: [Env.prod])
class NotificationsUsecaseImpl extends NotificationsUsecase {
  NotificationsUsecaseImpl(super.notificationsRepository);

  @override
  Future<DataState<NotificationsEntity>> notifications() async {
    DataState<NotificationsEntity> dataState =
        await notificationsRepository.notifications();
    return dataState;
  }

  @override
  Future<DataState<SuccessEntity>> markAsRead(int notifId) async {
    DataState<SuccessEntity> dataState =
        await notificationsRepository.markAsRead(notifId);
    return dataState;
  }
}
