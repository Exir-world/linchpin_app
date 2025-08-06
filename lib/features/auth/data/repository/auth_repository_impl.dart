import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/auth/data/data_source/api_auth.dart';
import 'package:linchpin/features/time_management/data/data_source/api_start_end_work.dart';
import 'package:linchpin/features/auth/data/models/login_model.dart';
import 'package:linchpin/features/auth/domain/entity/login_entity.dart';
import 'package:linchpin/features/auth/domain/repository/auth_repository.dart';

@Singleton(as: AuthRepository, env: [Env.prod])
class AuthRepositoryImpl extends AuthRepository {
  final ApiAuth apiAuth;
  final ApiStartEndWork apiStartEndWork;

  AuthRepositoryImpl(this.apiAuth, this.apiStartEndWork);
  @override
  Future<DataState<LoginEntity>> login(
    String phoneNumber,
    String password,
    String deviceUniqueCode,
    String firebase,
  ) async {
    try {
      Response response = await apiAuth.login(
        phoneNumber,
        password,
        deviceUniqueCode,
        firebase,
      );
      LoginEntity loginEntity = LoginModel.fromJson(response.data);
      return DataSuccess(loginEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
