import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/time_management/domain/entity/daily_entity.dart';

abstract class TimeManagementRepository {
  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily(
      String actionType, double lat, double lng);
}
