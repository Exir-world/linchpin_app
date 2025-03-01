import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiTimeMamagement {
  final Dio httpclient;
  ApiTimeMamagement(this.httpclient);

  // اطلاعات صفحه اصلی
  Future<dynamic> daily(String actionType, double lat, double lng) async {
    final response = await httpclient.post('attendance/main-page', data: {
      "actionType": actionType,
      "workReport": "string",
      "lat": lat,
      "lng": lng,
    });
    return response;
  }
}
