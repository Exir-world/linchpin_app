part of 'last_quarter_report_bloc.dart';

sealed class LastQuarterReportEvent {}

// گزارش کارکرد 12 ماه گذشته
final class MonthsEvent extends LastQuarterReportEvent {}

// گزارش کارکرد یک ماه
final class ReportEvent extends LastQuarterReportEvent {
  final String startDate;
  final String endDate;

  ReportEvent({required this.startDate, required this.endDate});
}

// گزارش کارکرد 12 ماه گذشته
final class DailyReportEvent extends LastQuarterReportEvent {
  final String date;

  DailyReportEvent(this.date);
}
