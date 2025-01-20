import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiTimeMamagement {
  final Dio httpclient;
  ApiTimeMamagement(this.httpclient);

  // اطلاعات صفحه اصلی
  Future<dynamic> daily() async {
    final response = await httpclient.get('attendance/daily');
    return response;
  }

  // ثبت ورود کاربر
  Future<dynamic> checkIn() async {
    final response = await httpclient.post('attendance/check-in');
    return response;
  }

  // ثبت خروج کاربر
  Future<dynamic> checkOut() async {
    final response = await httpclient.post('attendance/check-out');
    return response;
  }
}
