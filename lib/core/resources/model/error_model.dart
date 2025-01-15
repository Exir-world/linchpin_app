import 'package:flutter/material.dart';
import 'package:linchpin_app/core/resources/entity/error_entity.dart';

@immutable
class ErrorModel extends ErrorEntity {
  const ErrorModel({
    super.responseNumber,
    super.responseName,
    super.errorNumber,
    super.errorName,
    super.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        responseNumber: json['responseNumber'] as int?,
        responseName: json['responseName'] as String?,
        errorNumber: json['errorNumber'] as int?,
        errorName: json['errorName'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'responseNumber': responseNumber,
        'responseName': responseName,
        'errorNumber': errorNumber,
        'errorName': errorName,
        'message': message,
      };
}
