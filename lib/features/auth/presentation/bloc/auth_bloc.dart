import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/auth/domain/entity/login_entity.dart';
import 'package:linchpin/features/auth/domain/use_case/auth_usecase.dart';
import 'package:linchpin/features/auth/presentation/widgets/device_info.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase authUsecase;
  final DeviceInfo deviceInfo;
  AuthBloc(this.authUsecase, this.deviceInfo) : super(LoginInitialState()) {
    on<LoginEvent>(_loginEvent);
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());

    DataState dataState =
        await authUsecase.login(event.phoneNumber, event.password);

    if (dataState is DataSuccess) {
      final device_info = await deviceInfo.deviceInfo();

      emit(LoginCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(LoginErrorState(dataState.error!));
    }
  }
}
