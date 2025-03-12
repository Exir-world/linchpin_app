import 'package:flutter/foundation.dart';
import 'package:linchpin/features/performance_report/domain/entity/report_entity.dart';
import 'attendance.dart';

@immutable
class ReportModel extends ReportEntity {
  const ReportModel({
    super.title,
    super.attendanceMinutes,
    super.workMinutes,
    super.overDuration,
    super.lessDuration,
    super.leaveWithPayrollDuration,
    super.leaveWithoutPayrollDuration,
    super.attendances,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        title: json['title'] as String?,
        attendanceMinutes: json['attendanceMinutes'] as int?,
        workMinutes: json['workMinutes'] as int?,
        overDuration: json['overDuration'] as int?,
        lessDuration: json['lessDuration'] as int?,
        leaveWithPayrollDuration: json['leaveWithPayrollDuration'] as int?,
        leaveWithoutPayrollDuration:
            json['leaveWithoutPayrollDuration'] as int?,
        attendances: (json['attendances'] as List<dynamic>?)
            ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'attendanceMinutes': attendanceMinutes,
        'workMinutes': workMinutes,
        'overDuration': overDuration,
        'lessDuration': lessDuration,
        'leaveWithPayrollDuration': leaveWithPayrollDuration,
        'leaveWithoutPayrollDuration': leaveWithoutPayrollDuration,
        'attendances': attendances?.map((e) => e.toJson()).toList(),
      };
}
