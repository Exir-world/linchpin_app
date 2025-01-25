import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiLastQuarterReport {
  final Dio httpclient;
  ApiLastQuarterReport(this.httpclient);

  // گزارش کارکرد 12 ماه گذشته
  Future<dynamic> months() async {
    final response = await httpclient.get('attendance/report/months/12');
    return response;
  }
}
