import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/performance_report/domain/entity/daily_report_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/report_entity.dart';
import 'package:linchpin/features/performance_report/domain/use_case/last_quarter_report_usecase.dart';

part 'last_quarter_report_event.dart';
part 'last_quarter_report_state.dart';

@injectable
class LastQuarterReportBloc
    extends Bloc<LastQuarterReportEvent, LastQuarterReportState> {
  final LastQuarterReportUsecase lastQuarterReportUsecase;
  LastQuarterReportBloc(this.lastQuarterReportUsecase)
      : super(MonthsLoadingState()) {
    on<MonthsEvent>(_monthsEvent);
    on<ReportEvent>(_reportEvent);
    on<DailyReportEvent>(_dailyReportEvent);
  }
  Future<void> _monthsEvent(
      MonthsEvent event, Emitter<LastQuarterReportState> emit) async {
    emit(MonthsLoadingState());

    DataState dataState = await lastQuarterReportUsecase.months();

    if (dataState is DataSuccess) {
      emit(MonthsCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(MonthsErrorState(dataState.error!));
    }
  }

  FutureOr<void> _reportEvent(
      ReportEvent event, Emitter<LastQuarterReportState> emit) async {
    emit(ReportLoadingState());

    DataState dataState =
        await lastQuarterReportUsecase.report(event.startDate, event.endDate);

    if (dataState is DataSuccess) {
      emit(ReportCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(ReportErrorState(dataState.error!));
    }
  }

  FutureOr<void> _dailyReportEvent(
      DailyReportEvent event, Emitter<LastQuarterReportState> emit) async {
    emit(DailyReportLoadingState());

    DataState dataState =
        await lastQuarterReportUsecase.dailyReport(event.date);

    if (dataState is DataSuccess) {
      emit(DailyReportCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(DailyReportErrorState(dataState.error!));
    }
  }
}
