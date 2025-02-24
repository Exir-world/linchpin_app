import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/core/utils/handle_error.dart';
import 'package:Linchpin/features/notifications/data/data_source/api_notifications.dart';
import 'package:Linchpin/features/notifications/data/models/notifications_model/notifications_model.dart';
import 'package:Linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:Linchpin/features/notifications/domain/repository/notifications_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: NotificationsRepository, env: [Env.prod])
class NotificationsRepositoryImpl extends NotificationsRepository {
  final ApiNotifications apiNotifications;

  NotificationsRepositoryImpl(this.apiNotifications);
  @override
  Future<DataState<NotificationsEntity>> notifications() async {
    try {
      Response response = await apiNotifications.notifications();
      NotificationsEntity notificationsEntity =
          NotificationsModel.fromJson(response.data);
      return DataSuccess(notificationsEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
