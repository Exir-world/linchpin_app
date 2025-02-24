import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/time_management/domain/entity/daily_entity.dart';

abstract class TimeManagementRepository {
  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily(String actionType);
}
