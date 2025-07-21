import 'package:equatable/equatable.dart';
import 'package:linchpin/features/performance_report/data/model/report_model/attendance.dart';

class ReportEntity extends Equatable {
  final String? title;
  final int? attendanceMinutes;
  final int? workMinutes;
  final int? overDuration;
  final int? lessDuration;
  final int? leaveWithPayrollDuration;
  final int? leaveWithoutPayrollDuration;
  final List<Attendance>? attendances;

  const ReportEntity({
    this.title,
    this.attendanceMinutes,
    this.workMinutes,
    this.overDuration,
    this.lessDuration,
    this.leaveWithPayrollDuration,
    this.leaveWithoutPayrollDuration,
    this.attendances,
  });

  @override
  List<Object?> get props => [
        title,
        attendanceMinutes,
        workMinutes,
        overDuration,
        lessDuration,
        leaveWithPayrollDuration,
        leaveWithoutPayrollDuration,
        attendances,
      ];
}
