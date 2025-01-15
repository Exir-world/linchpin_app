import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/root/domain/entity/daily_entity.dart';
import 'package:linchpin_app/features/root/domain/use_case/root_usecase.dart';

part 'root_event.dart';
part 'root_state.dart';

@injectable
class RootBloc extends Bloc<RootEvent, RootState> {
  final RootUsecase rootUsecase;
  RootBloc(this.rootUsecase) : super(RootInitial()) {
    on<DailyEvent>(_dailyEvent);
  }

  Future<void> _dailyEvent(DailyEvent event, Emitter<RootState> emit) async {
    emit(DailyLoadingState());

    DataState dataState = await rootUsecase.daily();

    if (dataState is DataSuccess) {
      emit(DailyComplitedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(DailyErrorState(dataState.error!));
    }
  }
}
