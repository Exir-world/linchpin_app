import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/time_management/domain/entity/daily_entity.dart';

abstract class TimeManagementRepository {
  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily();
}
