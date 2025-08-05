import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/success_entity.dart';
import 'package:linchpin/core/resources/model/success_model.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/notifications/data/data_source/api_notifications.dart';
import 'package:linchpin/features/notifications/data/data_source/api_status_location.dart';
import 'package:linchpin/features/notifications/data/models/notifications_model/notifications_model.dart';
import 'package:linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:linchpin/features/notifications/domain/repository/notifications_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: NotificationsRepository, env: [Env.prod])
class NotificationsRepositoryImpl extends NotificationsRepository {
  final ApiNotifications apiNotifications;
  final ApiStatusLocation apiStatusLocation;

  NotificationsRepositoryImpl(this.apiNotifications, this.apiStatusLocation);
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

  @override
  Future<DataState<SuccessEntity>> markAsRead(int notifId) async {
    try {
      Response response = await apiNotifications.markAsRead(notifId);
      SuccessEntity successEntity = SuccessModel.fromJson(response.data);
      return DataSuccess(successEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<SuccessEntity>> statusLocation() async {
    // TODO: implement statusLocation
    throw UnimplementedError();
  }
}
