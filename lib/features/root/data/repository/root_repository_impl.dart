import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/utils/handle_error.dart';
import 'package:linchpin_app/features/root/data/data_source/api_root.dart';
import 'package:linchpin_app/features/root/data/models/daily_model/daily_model.dart';
import 'package:linchpin_app/features/root/domain/entity/daily_entity.dart';
import 'package:linchpin_app/features/root/domain/repository/root_repository.dart';

@Singleton(as: RootRepository, env: [Env.prod])
class RootRepositoryImpl extends RootRepository {
  final ApiRoot apiRoot;

  RootRepositoryImpl(this.apiRoot);
  @override
  Future<DataState<DailyEntity>> daily() async {
    try {
      Response response = await apiRoot.daily();
      DailyEntity dailyEntity = DailyModel.fromJson(response.data);
      return DataSuccess(dailyEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
