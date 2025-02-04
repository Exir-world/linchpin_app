import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiTimeMamagement {
  final Dio httpclient;
  ApiTimeMamagement(this.httpclient);

  // اطلاعات صفحه اصلی
  Future<dynamic> daily(String actionType) async {
    final response = await httpclient.post('attendance/main-page', data: {
      "actionType": actionType,
      "workReport": "string",
    });
    return response;
  }
}
