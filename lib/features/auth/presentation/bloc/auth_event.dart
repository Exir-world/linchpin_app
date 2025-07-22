part of 'auth_bloc.dart';

sealed class AuthEvent {}

// لاگین کاربر
class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;
  final String? deviceInfo;

  LoginEvent({
    required this.phoneNumber,
    required this.password,
    this.deviceInfo,
  });
}
