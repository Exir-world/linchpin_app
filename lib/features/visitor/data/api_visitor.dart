import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';

@singleton
class ApiVisitor {
  final Dio httpclient;
  ApiVisitor(this.httpclient);

//
  Future<dynamic> myVisitor(SetLocationRequest params) async {
    final response = await httpclient.post('user-check-points', data: {
      "userId": params.userId,
      "checkPointId": params.checkPointId,
      "lat": params.lat,
      "lng": params.lng,
      "report": params.report,
      // "attachments": params.attachments,
      "attachments": [
        for (var element in params.attachments!)
          {
            "filename": element.filename ?? '',
            "fileType": element.fileType ?? '',
            "fileUrl": element.fileUrl ?? '',
            "description": element.description ?? '',
          }
      ]
    });
    return response;
  }
}
