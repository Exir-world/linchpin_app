import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiUploadimage {
  final Dio httpclient;

  ApiUploadimage(this.httpclient);

  Future<dynamic> uploadImage(List<String>? files) async {
    final response = await httpclient
        .post('https://files.ex.pro/files/upload', data: {"files": files});
    return response;
  }
}
