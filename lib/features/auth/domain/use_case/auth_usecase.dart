import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/auth/domain/entity/login_entity.dart';
import 'package:linchpin_app/features/auth/domain/repository/auth_repository.dart';

@singleton
class AuthUsecase {
  final AuthRepository authRepository;

  AuthUsecase(this.authRepository);

  // ورود کاربر
  Future<DataState<LoginEntity>> login(
      String phoneNumber, String password) async {
    DataState<LoginEntity> dataState =
        await authRepository.login(phoneNumber, password);
    return dataState;
  }
}
