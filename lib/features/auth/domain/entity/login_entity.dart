import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? expires;

  const LoginEntity({this.accessToken, this.refreshToken, this.expires});

  @override
  List<Object?> get props => [accessToken, refreshToken, expires];
}
