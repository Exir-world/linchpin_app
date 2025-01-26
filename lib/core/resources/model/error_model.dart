import 'package:flutter/material.dart';
import 'package:linchpin_app/core/resources/entity/error_entity.dart';

@immutable
class ErrorModel extends ErrorEntity {
  const ErrorModel({
    super.statusCode,
    super.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
      };
}
