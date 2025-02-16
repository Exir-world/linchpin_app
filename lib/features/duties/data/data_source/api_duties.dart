import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiDuties {
  final Dio httpclient;
  ApiDuties(this.httpclient);

  // لیست وظایف خودم و دیگران
  Future<dynamic> tasks(
      String? startDate, String? endDate, int? priorityId, int? userId) async {
    final response =
        await httpclient.get('tasks', queryParameters: <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'priorityId': priorityId,
      'userId': userId
    });
    return response;
  }

  // جزئیات درخواست
  Future<dynamic> taskDetail(int taskId) async {
    final response = await httpclient.get('tasks/$taskId');
    return response;
  }

  // ساب تسک رو انجام دادم یا ندادم
  Future<dynamic> subtaskDone(int subtaskId, bool done) async {
    final response = await httpclient.post('tasks/subtask/done', data: {
      "subtaskId": subtaskId,
      "done": done,
    });
    return response;
  }
}
