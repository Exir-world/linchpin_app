import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/visitor/data/api_visitor.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/data/models/response/set_location_response.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

@Singleton(as: VisitorRepository, env: [Env.prod])
class VisitorRepositoryImpl extends VisitorRepository {
  final ApiVisitor apiVisitor;

  VisitorRepositoryImpl(this.apiVisitor);
  @override
  Future<DataState<bool>> myVisitor() async {
    // TODO: implement myVisitor
    throw UnimplementedError();
  }

  @override
  Future<DataState<SetLocationEntity>> setLocation(
      SetLocationRequest params) async {
    try {
      Response response = await apiVisitor.myVisitor(params);
      SetLocationEntity setLocationEntity =
          SetLocationResponse.fromJson(response.data);

      return DataSuccess(setLocationEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
