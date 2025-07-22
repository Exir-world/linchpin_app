import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

@Singleton(as: VisitorRepository, env: [Env.prod])
class VisitorRepositoryImpl extends VisitorRepository {
  final Dio httpclient;

  VisitorRepositoryImpl(this.httpclient);
  @override
  Future<DataState<bool>> myVisitor() async {
    // TODO: implement myVisitor
    throw UnimplementedError();
  }

  @override
  Future<DataState<SetLocationEntity>> uploadImage(
      SetLocationEntity params) async {
    final response = await httpclient.post('user-check-points', data: {
      "userId": params.userId,
      "checkPointId": params.checkPointId,
      "lat": params.lat,
      "lng": params.lng,
      "report": params.report,
      "attachments": [
        {
          "filename": "string",
          "fileType": "string",
          "fileUrl": "string",
          "description": "string"
        }
      ]
    });
    return response.data;
  }
}
