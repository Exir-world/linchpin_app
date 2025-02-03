part of 'auth_bloc.dart';

sealed class AuthState {}

final class LoginInitialState extends AuthState {}

// لاگین کاربر
final class LoginLoadingState extends AuthState {}

final class LoginCompletedState extends AuthState {
  final LoginEntity loginEntity;

  LoginCompletedState(this.loginEntity);
}

final class LoginErrorState extends AuthState {
  final String errorText;

  LoginErrorState(this.errorText);
}
