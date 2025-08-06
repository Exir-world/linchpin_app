import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/time_management/domain/entity/daily_entity.dart';
import 'package:linchpin/features/time_management/domain/entity/start_end_work_entity.dart';

abstract class TimeManagementRepository {
  //! اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily(
    String actionType,
    double lat,
    double lng,
  );

  //! ساعت شروع و پایان کار
  Future<DataState<StartEndWorkEntity>> startEndWork();
}
