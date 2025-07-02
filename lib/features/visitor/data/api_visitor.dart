import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiProperty {
  final Dio httpclient;
  ApiProperty(this.httpclient);

//
  Future<dynamic> myVisitor() async {
    final response = await httpclient.get('');
    return response;
  }
}
