import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/utils/handle_error.dart';
import 'package:linchpin_app/features/auth/data/data_source/api_auth.dart';
import 'package:linchpin_app/features/auth/data/models/login_model.dart';
import 'package:linchpin_app/features/auth/domain/entity/login_entity.dart';
import 'package:linchpin_app/features/auth/domain/repository/auth_repository.dart';

@Singleton(as: AuthRepository, env: [Env.prod])
class AuthRepositoryImpl extends AuthRepository {
  final ApiAuth apiAuth;

  AuthRepositoryImpl(this.apiAuth);
  @override
  Future<DataState<LoginEntity>> login(
      String phoneNumber, String password) async {
    try {
      Response response = await apiAuth.login(phoneNumber, password);
      LoginEntity loginEntity = LoginModel.fromJson(response.data);
      return DataSuccess(loginEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
