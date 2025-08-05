import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiStatusLocation {
  final Dio httpclient;

  ApiStatusLocation(this.httpclient);

  Future<dynamic> statusLocation() async {
    final response = await httpclient.post('notifications');
    return response;
  }
}
