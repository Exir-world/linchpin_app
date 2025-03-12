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

  // گزارش کارکرد یک ماه
  Future<dynamic> report(String startDate, String endDate) async {
    final response = await httpclient.post('attendance/report', data: {
      "startDate": startDate,
      "endDate": endDate,
    });
    return response;
  }

  // گزارش کارکرد یک روز
  Future<dynamic> dailyReport(String date) async {
    final response = await httpclient.post('attendance/daily/report', data: {
      "date": date,
    });
    return response;
  }
}
