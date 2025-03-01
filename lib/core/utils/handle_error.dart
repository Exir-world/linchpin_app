import 'package:dio/dio.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/error_entity.dart';
import 'package:linchpin/core/resources/model/error_model.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';

Future<DataState<T>> handleError<T>(DioException e) async {
  if (e.response == null) {
    if (e.type == DioExceptionType.receiveTimeout) {
      return DataFailed(
          'It looks like your internet is connected, but the server took some time to respond.');
    } else {
      return DataFailed('Check your internet or vpn status.');
    }
  } else if (e.response!.statusCode == 401) {
    PrefService prefService = PrefService();
    final value = await prefService.readCacheString(SharedKey.jwtToken);
    if (value != null) {
      return DataFailed('You have expired, please login again.');
    } else {
      return DataFailed('To view this section, please login first');
    }
  } else if (e.response!.statusCode == 403) {
    return DataFailed('Access to this section is restricted for you');
  } else if (e.response!.statusCode! >= 500) {
    return DataFailed('The server is being updated. Please be patient.');
  } else {
    ErrorEntity errorEntity = ErrorModel.fromJson(e.response!.data);
    return DataFailed(errorEntity.message!);
  }
}
