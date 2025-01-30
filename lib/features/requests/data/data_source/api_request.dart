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

  // ثبت درخواست
  Future<dynamic> requestCreate({
    required String type,
    String? description,
    required String startTime,
    String? endTime,
  }) async {
    final response = await httpclient.post('requests/create', data: {
      "type": type,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
    });
    return response;
  }

  // لیست نوع درخواست ها
  Future<dynamic> requestTypes() async {
    final response = await httpclient.get('requests/request-types');
    return response;
  }
}
