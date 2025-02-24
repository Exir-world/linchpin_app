import 'package:flutter/foundation.dart';
import 'package:Linchpin/features/auth/domain/entity/login_entity.dart';

@immutable
class LoginModel extends LoginEntity {
  const LoginModel({super.accessToken, super.refreshToken, super.expires});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        expires: json['expires'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expires': expires,
      };
}
