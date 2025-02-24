import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/core/resources/entity/success_entity.dart';
import 'package:Linchpin/features/requests/domain/entity/request_create_entity.dart';
import 'package:Linchpin/features/requests/domain/entity/request_types_entity.dart';
import 'package:Linchpin/features/requests/domain/entity/request_user_entity.dart';

abstract class RequestRepository {
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
