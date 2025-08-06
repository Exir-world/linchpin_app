import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_key.dart';
import 'package:linchpin/core/shared_preferences/shared_preferences_service.dart';
import 'package:linchpin/features/time_management/domain/entity/daily_entity.dart';
import 'package:linchpin/features/time_management/domain/use_case/start_end_work.dart';
import 'package:linchpin/features/time_management/domain/use_case/time_management_usecase.dart';

part 'time_management_event.dart';
part 'time_management_state.dart';

@injectable
class TimeManagementBloc
    extends Bloc<TimeManagementEvent, TimeManagementState> {
  final TimeManagementUsecase timeManagementUsecase;
  final StartEndWorkUseCase startEndWorkUseCase;
  TimeManagementBloc(
    this.timeManagementUsecase,
    this.startEndWorkUseCase,
  ) : super(DailyLoadingState()) {
    on<DailyEvent>(_dailyEvent);
    on<StartEndWorkEvent>(_startEndWorkEvent);
  }

  Future<void> _dailyEvent(
      DailyEvent event, Emitter<TimeManagementState> emit) async {
    emit(DailyLoadingState());

    DataState dataState = await timeManagementUsecase.daily(
        event.actionType, event.lat, event.lng);

    if (dataState is DataSuccess) {
      emit(DailyComplitedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(DailyErrorState(dataState.error!));
    }
  }

  FutureOr<void> _startEndWorkEvent(
      StartEndWorkEvent event, Emitter<TimeManagementState> emit) async {
    try {
      PrefService prefService = PrefService();
      emit(StartEndWorkLoading());
      DataState dataState = await startEndWorkUseCase.startEndWork();

      if (dataState is DataSuccess) {
        await prefService.createCacheString(
          SharedKey.startTime,
          dataState.data.startTime,
        );
        await prefService.createCacheString(
          SharedKey.endTime,
          dataState.data.endTime,
        );
      }

      if (dataState is DataFailed) {
        emit(DailyErrorState(dataState.error!));
      }
    } catch (e) {
      emit(DailyErrorState(e.toString()));
    }
  }
}
