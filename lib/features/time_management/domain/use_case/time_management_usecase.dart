import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/time_management/domain/entity/daily_entity.dart';
import 'package:linchpin_app/features/time_management/domain/repository/time_management_repository.dart';

@singleton
class TimeManagementUsecase {
  final TimeManagementRepository timeManagementRepository;

  TimeManagementUsecase(this.timeManagementRepository);

  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily(String actionType) async {
    DataState<DailyEntity> dataState =
        await timeManagementRepository.daily(actionType);
    return dataState;
  }
}
