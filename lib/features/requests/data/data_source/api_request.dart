import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiRequest {
  final Dio httpclient;
  ApiRequest(this.httpclient);

  // لیست درخواست های کاربر
  Future<dynamic> requestsUser() async {
    final response = await httpclient.get('requests/user');
    return response;
  }

  // لغو درخواست
  Future<dynamic> requestCancel(String id) async {
    final response = await httpclient.delete('requests/cancel/$id');
    return response;
  }
}
