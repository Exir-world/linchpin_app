import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiProperty {
  final Dio httpclient;
  ApiProperty(this.httpclient);

  // دریافت لیست اموال و جزئیات هر اموال
  Future<dynamic> myProperties() async {
    final response = await httpclient.get('property-user/my-properties');
    return response;
  }
}
