import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/time_management/domain/entity/daily_entity.dart';
import 'package:linchpin/features/time_management/domain/repository/time_management_repository.dart';

abstract class TimeManagementUsecase {
  final TimeManagementRepository timeManagementRepository;

  TimeManagementUsecase(this.timeManagementRepository);

  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily(
      String actionType, double lat, double lng);
}

@Singleton(as: TimeManagementUsecase, env: [Env.prod])
class TimeManagementUsecaseImpl extends TimeManagementUsecase {
  TimeManagementUsecaseImpl(super.timeManagementRepository);

  @override
  Future<DataState<DailyEntity>> daily(
      String actionType, double lat, double lng) async {
    DataState<DailyEntity> dataState =
        await timeManagementRepository.daily(actionType, lat, lng);
    return dataState;
  }
}
