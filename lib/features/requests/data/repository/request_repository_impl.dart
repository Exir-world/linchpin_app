import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/success_entity.dart';
import 'package:linchpin/core/resources/model/success_model.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/requests/data/data_source/api_request.dart';
import 'package:linchpin/features/requests/data/model/request_create_model.dart';
import 'package:linchpin/features/requests/data/model/request_types_model/request_types_model.dart';
import 'package:linchpin/features/requests/data/model/request_user_model/request_user_model.dart';
import 'package:linchpin/features/requests/domain/entity/request_create_entity.dart';
import 'package:linchpin/features/requests/domain/entity/request_types_entity.dart';
import 'package:linchpin/features/requests/domain/entity/request_user_entity.dart';
import 'package:linchpin/features/requests/domain/repository/request_repository.dart';

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

  @override
  Future<DataState<List<RequestTypesEntity>>> requestTypes() async {
    try {
      Response response = await apiRequest.requestTypes();
      List<RequestTypesEntity> requestTypesEntity =
          List<RequestTypesEntity>.from(
              response.data.map((model) => RequestTypesModel.fromJson(model)));
      return DataSuccess(requestTypesEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<RequestCreateEntity>> requestCreate(
      {required String type,
      String? description,
      required String startTime,
      String? endTime}) async {
    try {
      Response response = await apiRequest.requestCreate(
          type: type,
          description: description,
          startTime: startTime,
          endTime: endTime);
      RequestCreateEntity requestCreateEntity =
          RequestCreateModel.fromJson(response.data);
      return DataSuccess(requestCreateEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
