import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiAuth {
  final Dio httpclient;
  ApiAuth(this.httpclient);

  // ورود کاربر
  Future<dynamic> login(
    String phoneNumber,
    String password,
    String deviceUniqueCode,
    String firebase,
  ) async {
    final response = await httpclient.post(
      'auth/login',
      data: {
        "phoneNumber": "+98$phoneNumber",
        "password": password,
        "deviceUniqueCode": deviceUniqueCode,
        "firebase": firebase,
      },
    );
    return response;
  }
}
