part of 'auth_bloc.dart';

sealed class AuthEvent {}

// لاگین کاربر
class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  LoginEvent({required this.phoneNumber, required this.password});
}
