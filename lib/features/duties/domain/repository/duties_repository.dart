import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/duties/domain/entity/tasks_entity.dart';

abstract class DutiesRepository {
  // لیست وظایف خودم و دیگران
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId);
}
