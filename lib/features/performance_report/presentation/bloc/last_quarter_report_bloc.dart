import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/performance_report/domain/entity/months_entity.dart';
import 'package:linchpin_app/features/performance_report/domain/use_case/last_quarter_report_usecase.dart';

part 'last_quarter_report_event.dart';
part 'last_quarter_report_state.dart';

@injectable
class LastQuarterReportBloc
    extends Bloc<LastQuarterReportEvent, LastQuarterReportState> {
  final LastQuarterReportUsecase lastQuarterReportUsecase;
  LastQuarterReportBloc(this.lastQuarterReportUsecase)
      : super(MonthsLoadingState()) {
    on<MonthsEvent>(_monthsEvent);
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
}
