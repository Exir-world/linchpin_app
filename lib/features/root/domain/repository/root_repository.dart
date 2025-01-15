import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/root/domain/entity/daily_entity.dart';

abstract class RootRepository {
  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily();
}
