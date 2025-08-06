import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiStartEndWork {
  final Dio httpclient;

  ApiStartEndWork(this.httpclient);
  Future<dynamic> startEndWork() async {
    final response = await httpclient.get(
      'attendance/work-times-for-user',
    );
    return response;
  }
}
