import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiNotifications {
  final Dio httpclient;
  ApiNotifications(this.httpclient);

  // لیست اعلانات
  Future<dynamic> notifications() async {
    final response = await httpclient.get('notifications');
    return response;
  }
}
