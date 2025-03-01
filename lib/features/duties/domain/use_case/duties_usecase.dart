import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/duties/domain/entity/task_detail_entity.dart';
import 'package:linchpin/features/duties/domain/entity/tasks_entity.dart';
import 'package:linchpin/features/duties/domain/repository/duties_repository.dart';

abstract class DutiesUsecase {
  final DutiesRepository dutiesRepository;

  DutiesUsecase(this.dutiesRepository);

  // لیست وظایف خودم و دیگران
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId);

  // لیست وظایف خودم و دیگران (همه روزها)
  Future<DataState<TasksEntity>> allTasks(
      String? startDate, String? endDate, int? priorityId, int? userId);

  // جزئیات درخواست
  Future<DataState<TaskDetailEntity>> taskDetail(int taskId);

  // ساب تسک رو انجام دادم یا ندادم
  Future<DataState<TaskDetailEntity>> subtaskDone(int subtaskId, bool done);
}

@Singleton(as: DutiesUsecase, env: [Env.prod])
class DutiesUsecaseImpl extends DutiesUsecase {
  DutiesUsecaseImpl(super.dutiesRepository);

  @override
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    DataState<TasksEntity> dataState =
        await dutiesRepository.tasks(startDate, endDate, priorityId, userId);
    return dataState;
  }

  @override
  Future<DataState<TasksEntity>> allTasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    DataState<TasksEntity> dataState =
        await dutiesRepository.tasks(startDate, endDate, priorityId, userId);
    return dataState;
  }

  @override
  Future<DataState<TaskDetailEntity>> taskDetail(int taskId) async {
    DataState<TaskDetailEntity> dataState =
        await dutiesRepository.taskDetail(taskId);
    return dataState;
  }

  @override
  Future<DataState<TaskDetailEntity>> subtaskDone(
      int subtaskId, bool done) async {
    DataState<TaskDetailEntity> dataState =
        await dutiesRepository.subtaskDone(subtaskId, done);
    return dataState;
  }
}
