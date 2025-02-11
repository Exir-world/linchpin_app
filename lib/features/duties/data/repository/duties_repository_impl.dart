import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/utils/handle_error.dart';
import 'package:linchpin_app/features/duties/data/data_source/api_duties.dart';
import 'package:linchpin_app/features/duties/data/models/tasks_model/tasks_model.dart';
import 'package:linchpin_app/features/duties/domain/entity/tasks_entity.dart';
import 'package:linchpin_app/features/duties/domain/repository/duties_repository.dart';

@Singleton(as: DutiesRepository, env: [Env.prod])
class DutiesRepositoryImpl extends DutiesRepository {
  final ApiDuties apiDuties;

  DutiesRepositoryImpl(this.apiDuties);
  @override
  Future<DataState<TasksEntity>> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    try {
      Response response =
          await apiDuties.tasks(startDate, endDate, priorityId, userId);
      TasksEntity tasksEntity = TasksModel.fromJson(response.data);
      return DataSuccess(tasksEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
