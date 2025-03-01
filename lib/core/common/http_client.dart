import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/common/constants.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';

@module
@lazySingleton
abstract class DioProvider {
  final Dio httpclient;

  DioProvider()
      : httpclient = Dio(
          BaseOptions(
            baseUrl: Constants.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
          ),
        ) {
    httpclient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          PrefService prefService = PrefService();
          String? token = await prefService.readCacheString(SharedKey.jwtToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            PrefService prefService = PrefService();
            String? refreshToken =
                await prefService.readCacheString(SharedKey.refreshToken);

            if (refreshToken != null) {
              try {
                /// ✅ از تابع `refresh` برای دریافت توکن جدید استفاده می‌کنیم
                final response = await refresh(refreshToken);

                if (response.statusCode == 200) {
                  // ذخیره توکن جدید
                  String newAccessToken = response.data['accessToken'];
                  String newRefreshToken = response.data['refreshToken'];
                  int newExpires = response.data['expires'];

                  await prefService.createCacheString(
                      SharedKey.jwtToken, newAccessToken);
                  await prefService.createCacheString(
                      SharedKey.refreshToken, newRefreshToken);
                  await prefService.createCacheInt(
                      SharedKey.expires, newExpires);

                  // درخواست اصلی را دوباره ارسال کن
                  e.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';

                  final opts = Options(
                    method: e.requestOptions.method,
                    headers: e.requestOptions.headers,
                  );

                  final retryResponse = await httpclient.request(
                    e.requestOptions.path,
                    options: opts,
                    data: e.requestOptions.data,
                    queryParameters: e.requestOptions.queryParameters,
                  );

                  return handler.resolve(retryResponse);
                }
              } catch (_) {
                // در صورت نامعتبر بودن رفرش توکن، کاربر را لاگ‌اوت کن
                await prefService.removeCache(SharedKey.jwtToken);
                await prefService.removeCache(SharedKey.refreshToken);
                await prefService.removeCache(SharedKey.expires);
                return handler.reject(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// ✅ متد رفرش توکن که درخواست جدید می‌فرستد
  Future<Response> refresh(String refreshToken) async {
    final response = await httpclient.post(
      'auth/refresh',
      data: {
        "refreshToken": refreshToken,
      },
    );
    return response;
  }
}
