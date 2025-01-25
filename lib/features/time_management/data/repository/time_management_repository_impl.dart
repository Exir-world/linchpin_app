import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/utils/handle_error.dart';
import 'package:linchpin_app/features/time_management/data/data_source/api_time_mamagement.dart';
import 'package:linchpin_app/features/time_management/data/models/daily_model/daily_model.dart';
import 'package:linchpin_app/features/time_management/domain/entity/daily_entity.dart';
import 'package:linchpin_app/features/time_management/domain/repository/time_management_repository.dart';

@Singleton(as: TimeManagementRepository, env: [Env.prod])
class TimeManagementRepositoryImpl extends TimeManagementRepository {
  final ApiTimeMamagement apiTimeMamagement;

  TimeManagementRepositoryImpl(this.apiTimeMamagement);
  @override
  Future<DataState<DailyEntity>> daily(String actionType) async {
    try {
      Response response = await apiTimeMamagement.daily(actionType);
      DailyEntity dailyEntity = DailyModel.fromJson(response.data);
      return DataSuccess(dailyEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
