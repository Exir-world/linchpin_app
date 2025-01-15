import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/common/constants.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin_app/core/shared_preferences/shared_preferences_service.dart';

@module
@lazySingleton
abstract class DioProvider {
  final httpclient = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          PrefService prefService = PrefService();
          prefService.readCacheString(SharedKey.jwtToken).then(
            (value) {
              if (value != null) {
                options.headers['Authorization'] = 'Bearer $value';
                return handler.next(options);
              } else {
                return handler.next(options);
              }
            },
          );
        },
      ),
    );
}
