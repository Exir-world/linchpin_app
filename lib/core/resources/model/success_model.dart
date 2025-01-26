import 'package:flutter/material.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';

@immutable
class SuccessModel extends SuccessEntity {
  const SuccessModel({
    super.message,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
