import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
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
    PrefService prefService = PrefService();
    String firebaseToken = '';
    //! گرفتن توکن FCM
    await FirebaseMessaging.instance.getToken().then((token) async {
      firebaseToken = token ?? '';
      await prefService.createCacheString(
        SharedKey.firebaseToken,
        token ?? '',
      );
    });
    final device_info = await deviceInfo.deviceInfo();
    emit(LoginLoadingState());

    DataState dataState = await authUsecase.login(
      event.phoneNumber,
      event.password,
      device_info.id ?? '',
      firebaseToken,
    );

    if (dataState is DataSuccess) {
      emit(LoginCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(LoginErrorState(dataState.error!));
    }
  }
}
