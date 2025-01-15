import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiRoot {
  final Dio httpclient;
  ApiRoot(this.httpclient);

  // اطلاعات صفحه اصلی
  Future<dynamic> daily() async {
    final response =
        await httpclient.get('attendance/daily');
    return response;
  }
}
