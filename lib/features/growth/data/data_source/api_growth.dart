import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiGrowth {
  final Dio httpclient;
  ApiGrowth(this.httpclient);

  // اطلاعات توسعه فردی
  Future<dynamic> userSelf() async {
    final response = await httpclient.get('user-self-improvement');
    return response;
  }

  // ثبت گزارش توسعه فردی
  Future<dynamic> userSelfAdd(int improvementId, String description) async {
    final response = await httpclient.post('user-self-improvement', data: {
      "improvementId": improvementId,
      "userScore": 13,
      "description": description,
    });
    return response;
  }
}
