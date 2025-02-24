import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/core/utils/handle_error.dart';
import 'package:Linchpin/features/growth/data/data_source/api_growth.dart';
import 'package:Linchpin/features/growth/data/models/user_self_model/user_self_model.dart';
import 'package:Linchpin/features/growth/domain/entity/user_self_entity.dart';
import 'package:Linchpin/features/growth/domain/repository/growth_repository.dart';

@Singleton(as: GrowthRepository, env: [Env.prod])
class GrowthRepositoryImpl extends GrowthRepository {
  final ApiGrowth apiGrowth;

  GrowthRepositoryImpl(this.apiGrowth);
  @override
  Future<DataState<UserSelfEntity>> userSelf() async {
    try {
      Response response = await apiGrowth.userSelf();
      UserSelfEntity userSelfEntity = UserSelfModel.fromJson(response.data);
      return DataSuccess(userSelfEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description) async {
    try {
      Response response =
          await apiGrowth.userSelfAdd(improvementId, description);
      UserSelfEntity userSelfEntity = UserSelfModel.fromJson(response.data);
      return DataSuccess(userSelfEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
