import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_create_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_types_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_user_entity.dart';

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
    required String startTime,
    String? description,
    String? endTime,
  });
}
