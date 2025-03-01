import 'package:flutter/foundation.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';

@immutable
class MonthsModel extends MonthsEntity {
  const MonthsModel({
    super.date,
    super.month,
    super.workMinutes,
    super.overDuration,
    super.lessDuration,
    super.leaveDuration,
  });

  factory MonthsModel.fromJson(Map<String, dynamic> json) => MonthsModel(
        date: json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String),
        month: json['month'] as int?,
        workMinutes: json['workMinutes'] as int?,
        overDuration: json['overDuration'] as int?,
        lessDuration: json['lessDuration'] as int?,
        leaveDuration: json['leaveDuration'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'date': date?.toIso8601String(),
        'month': month,
        'workMinutes': workMinutes,
        'overDuration': overDuration,
        'lessDuration': lessDuration,
        'leaveDuration': leaveDuration,
      };
}
