import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_user_entity.dart';
import 'package:linchpin_app/features/requests/domain/repository/request_repository.dart';

@singleton
class RequestUsecase {
  final RequestRepository requestRepository;

  RequestUsecase(this.requestRepository);

  // لیست درخواست های کاربر
  Future<DataState<List<RequestUserEntity>>> requestsUser() async {
    DataState<List<RequestUserEntity>> dataState =
        await requestRepository.requestsUser();
    return dataState;
  }

  // لغو درخواست
  Future<DataState<SuccessEntity>> requestCancel(String id) async {
    DataState<SuccessEntity> dataState =
        await requestRepository.requestCancel(id);
    return dataState;
  }
}
