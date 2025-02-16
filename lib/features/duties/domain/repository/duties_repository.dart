import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/duties/domain/entity/task_detail_entity.dart';
import 'package:linchpin_app/features/duties/domain/entity/tasks_entity.dart';

abstract class DutiesRepository {
  // لیست وظایف خودم و دیگران
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId);

  // جزئیات درخواست
  Future<DataState<TaskDetailEntity>> taskDetail(int taskId);

  // ساب تسک رو انجام دادم یا ندادم
  Future<DataState<TaskDetailEntity>> subtaskDone(int subtaskId, bool done);
}
