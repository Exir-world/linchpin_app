import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:Linchpin/features/notifications/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationsUsecase {
  final NotificationsRepository notificationsRepository;

  NotificationsUsecase(this.notificationsRepository);

  // لیست اعلانات
  Future<DataState<NotificationsEntity>> notifications();
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
}
