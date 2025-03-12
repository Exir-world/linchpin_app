part of 'last_quarter_report_bloc.dart';

sealed class LastQuarterReportState {}

// گزارش کارکرد 12 ماه گذشته
final class MonthsLoadingState extends LastQuarterReportState {}

final class MonthsCompletedState extends LastQuarterReportState {
  final List<MonthsEntity> monthsEntity;

  MonthsCompletedState(this.monthsEntity);
}

final class MonthsErrorState extends LastQuarterReportState {
  final String errorText;

  MonthsErrorState(this.errorText);
}

// گزارش کارکرد یک ماه
final class ReportLoadingState extends LastQuarterReportState {}

final class ReportCompletedState extends LastQuarterReportState {
  final ReportEntity reportEntity;

  ReportCompletedState(this.reportEntity);
}

final class ReportErrorState extends LastQuarterReportState {
  final String errorText;

  ReportErrorState(this.errorText);
}

// گزارش کارکرد یک روز
final class DailyReportLoadingState extends LastQuarterReportState {}

final class DailyReportCompletedState extends LastQuarterReportState {
  final DailyReportEntity dailyReportEntity;

  DailyReportCompletedState(this.dailyReportEntity);
}

final class DailyReportErrorState extends LastQuarterReportState {
  final String errorText;

  DailyReportErrorState(this.errorText);
}
