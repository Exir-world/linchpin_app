part of 'last_quarter_report_bloc.dart';

sealed class LastQuarterReportState {}

final class MonthsLoadingState extends LastQuarterReportState {}

final class MonthsCompletedState extends LastQuarterReportState {
  final List<MonthsEntity> monthsEntity;

  MonthsCompletedState(this.monthsEntity);
}

final class MonthsErrorState extends LastQuarterReportState {
  final String errorText;

  MonthsErrorState(this.errorText);
}
