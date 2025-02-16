import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_create_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_types_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_user_entity.dart';
import 'package:linchpin_app/features/requests/domain/repository/request_repository.dart';

abstract class RequestUsecase {
  final RequestRepository requestRepository;

  RequestUsecase(this.requestRepository);

  // لیست درخواست های کاربر
  Future<DataState<List<RequestUserEntity>>> requestsUser();

  // لغو درخواست
  Future<DataState<SuccessEntity>> requestCancel(String id);

  // لیست نوع درخواست ها
  Future<DataState<List<RequestTypesEntity>>> requestTypes();

  // ثبت درخواست
  Future<DataState<RequestCreateEntity>> requestCreate({
    required String type,
    String? description,
    required String startTime,
    String? endTime,
  });
}

@Singleton(as: RequestUsecase, env: [Env.prod])
class RequestUsecaseImpl extends RequestUsecase {
  RequestUsecaseImpl(super.requestRepository);

  @override
  Future<DataState<List<RequestUserEntity>>> requestsUser() async {
    DataState<List<RequestUserEntity>> dataState =
        await requestRepository.requestsUser();
    return dataState;
  }

  @override
  Future<DataState<SuccessEntity>> requestCancel(String id) async {
    DataState<SuccessEntity> dataState =
        await requestRepository.requestCancel(id);
    return dataState;
  }

  @override
  Future<DataState<List<RequestTypesEntity>>> requestTypes() async {
    DataState<List<RequestTypesEntity>> dataState =
        await requestRepository.requestTypes();
    return dataState;
  }

  @override
  Future<DataState<RequestCreateEntity>> requestCreate(
      {required String type,
      String? description,
      required String startTime,
      String? endTime}) async {
    DataState<RequestCreateEntity> dataState =
        await requestRepository.requestCreate(
            type: type,
            description: description,
            startTime: startTime,
            endTime: endTime);
    return dataState;
  }
}
