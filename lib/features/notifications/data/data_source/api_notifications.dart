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

  // علامت زدن اعلان
  Future<dynamic> markAsRead(int notifId) async {
    final response =
        await httpclient.patch('notifications/mark-as-read', data: {
      "id": notifId,
    });
    return response;
  }
}
