import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/features/time_management/domain/entity/daily_entity.dart';
import 'package:Linchpin/features/time_management/domain/use_case/time_management_usecase.dart';

part 'time_management_event.dart';
part 'time_management_state.dart';

@injectable
class TimeManagementBloc
    extends Bloc<TimeManagementEvent, TimeManagementState> {
  final TimeManagementUsecase timeManagementUsecase;
  TimeManagementBloc(this.timeManagementUsecase) : super(DailyLoadingState()) {
    on<DailyEvent>(_dailyEvent);
  }

  Future<void> _dailyEvent(
      DailyEvent event, Emitter<TimeManagementState> emit) async {
    emit(DailyLoadingState());

    DataState dataState = await timeManagementUsecase.daily(event.actionType);

    if (dataState is DataSuccess) {
      emit(DailyComplitedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(DailyErrorState(dataState.error!));
    }
  }
}
