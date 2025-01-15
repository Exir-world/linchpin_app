import 'package:flutter/foundation.dart';
import 'package:linchpin_app/features/root/domain/entity/daily_entity.dart';
import 'data.dart';

@immutable
class DailyModel extends DailyEntity {
  const DailyModel({super.statusCode, super.message, super.data});

  factory DailyModel.fromJson(Map<String, dynamic> json) => DailyModel(
        statusCode: json['statusCode'] as int?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}
