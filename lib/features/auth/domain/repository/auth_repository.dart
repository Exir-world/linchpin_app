import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/auth/domain/entity/login_entity.dart';

abstract class AuthRepository {
  // ورود کاربر
  Future<DataState<LoginEntity>> login(String phoneNumber, String password);
}
