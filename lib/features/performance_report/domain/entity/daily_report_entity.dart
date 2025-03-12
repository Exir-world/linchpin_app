import 'package:equatable/equatable.dart';
import 'package:linchpin/features/performance_report/data/model/daily_report_model/attendance.dart';

class DailyReportEntity extends Equatable {
  final String? title;
  final int? attendanceMinutes;
  final int? workMinutes;
  final List<Attendance>? attendances;

  const DailyReportEntity(
      {this.title, this.attendanceMinutes, this.workMinutes, this.attendances});

  @override
  List<Object?> get props =>
      [title, attendanceMinutes, workMinutes, attendances];
}
