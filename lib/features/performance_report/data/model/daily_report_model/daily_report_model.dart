import 'package:flutter/foundation.dart';
import 'package:linchpin/features/performance_report/domain/entity/daily_report_entity.dart';
import 'attendance.dart';

@immutable
class DailyReportModel extends DailyReportEntity {
  const DailyReportModel({
    super.title,
    super.attendanceMinutes,
    super.workMinutes,
    super.attendances,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      title: json['title'] as String?,
      attendanceMinutes: json['attendanceMinutes'] as int?,
      workMinutes: json['workMinutes'] as int?,
      attendances: (json['attendances'] as List<dynamic>?)
          ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'attendanceMinutes': attendanceMinutes,
        'workMinutes': workMinutes,
        'attendances': attendances?.map((e) => e.toJson()).toList(),
      };
}
