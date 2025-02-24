import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/auth/domain/entity/login_entity.dart';
import 'package:Linchpin/features/auth/domain/use_case/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase authUsecase;
  AuthBloc(this.authUsecase) : super(LoginInitialState()) {
    on<LoginEvent>(_loginEvent);
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());

    DataState dataState =
        await authUsecase.login(event.phoneNumber, event.password);

    if (dataState is DataSuccess) {
      emit(LoginCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(LoginErrorState(dataState.error!));
    }
  }
}
