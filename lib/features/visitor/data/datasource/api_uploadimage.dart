import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiUploadimage {
  final Dio httpclient;

  ApiUploadimage(this.httpclient);

  Future<dynamic> uploadImage(FormData? files) async {
    final response = await Dio().post(
      'https://files.ex.pro/files/upload',
      data: files,
      options: Options(headers: {
        'Content-Type': 'multipart/form-data',
      }),
    );
    return response;
  }
}
