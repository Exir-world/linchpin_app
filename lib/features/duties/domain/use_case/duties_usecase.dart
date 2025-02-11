import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/duties/domain/entity/tasks_entity.dart';
import 'package:linchpin_app/features/duties/domain/repository/duties_repository.dart';

@singleton
class DutiesUsecase {
  final DutiesRepository dutiesRepository;

  DutiesUsecase(this.dutiesRepository);

  // لیست وظایف خودم و دیگران
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    DataState<TasksEntity> dataState =
        await dutiesRepository.tasks(startDate, endDate, priorityId, userId);
    return dataState;
  }

  // لیست وظایف خودم و دیگران (همه روزها)
  Future<DataState<TasksEntity>> allTasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    DataState<TasksEntity> dataState =
        await dutiesRepository.tasks(startDate, endDate, priorityId, userId);
    return dataState;
  }
}
