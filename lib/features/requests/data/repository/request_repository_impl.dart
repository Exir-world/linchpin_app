import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/core/resources/model/success_model.dart';
import 'package:linchpin_app/core/utils/handle_error.dart';
import 'package:linchpin_app/features/requests/data/data_source/api_request.dart';
import 'package:linchpin_app/features/requests/data/model/request_user_model/request_user_model.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_user_entity.dart';
import 'package:linchpin_app/features/requests/domain/repository/request_repository.dart';

@Singleton(as: RequestRepository, env: [Env.prod])
class RequestRepositoryImpl extends RequestRepository {
  final ApiRequest apiRequest;

  RequestRepositoryImpl(this.apiRequest);
  @override
  Future<DataState<List<RequestUserEntity>>> requestsUser() async {
    try {
      Response response = await apiRequest.requestsUser();
      List<RequestUserEntity> monthsEntity = List<RequestUserEntity>.from(
          response.data.map((model) => RequestUserModel.fromJson(model)));
      return DataSuccess(monthsEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<SuccessEntity>> requestCancel(String id) async {
    try {
      Response response = await apiRequest.requestCancel(id);
      SuccessEntity successEntity = SuccessModel.fromJson(response.data);
      return DataSuccess(successEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
