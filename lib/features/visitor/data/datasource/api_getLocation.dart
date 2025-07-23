import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiGetlocation {
  final Dio httpclient;

  ApiGetlocation(this.httpclient);

  Future<dynamic> getLocation() async {
    final response = await httpclient.get('user-check-points/user');
    return response;
  }
}
