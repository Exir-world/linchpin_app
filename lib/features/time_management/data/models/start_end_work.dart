import 'package:flutter/foundation.dart';
import 'package:linchpin/features/time_management/domain/entity/start_end_work_entity.dart';

@immutable
class StartEndWorkModel extends StartEndWorkEntity {
  const StartEndWorkModel({required super.startTime, required super.endTime});

  factory StartEndWorkModel.fromJson(Map<String, dynamic> json) =>
      StartEndWorkModel(
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
      };
}
