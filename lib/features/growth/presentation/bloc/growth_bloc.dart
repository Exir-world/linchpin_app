import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/growth/domain/entity/user_self_entity.dart';
import 'package:linchpin_app/features/growth/domain/use_case/growth_usecase.dart';

part 'growth_event.dart';
part 'growth_state.dart';

@injectable
class GrowthBloc extends Bloc<GrowthEvent, GrowthState> {
  final GrowthUsecase growthUsecase;
  GrowthBloc(this.growthUsecase) : super(GrowthInitial()) {
    on<UserSelfEvent>(_userSelfEvent);
    on<UserSelfAddEvent>(_userSelfAddEvent);
  }

  FutureOr<void> _userSelfEvent(
      UserSelfEvent event, Emitter<GrowthState> emit) async {
    emit(UserSelfLoadingState());
    DataState dataState = await growthUsecase.userSelf();

    if (dataState is DataSuccess) {
      emit(UserSelfCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(UserSelfErrorState(dataState.error!));
    }
  }

  FutureOr<void> _userSelfAddEvent(
      UserSelfAddEvent event, Emitter<GrowthState> emit) async {
    emit(UserSelfAddLoadingState());
    DataState dataState =
        await growthUsecase.userSelfAdd(event.improvementId, event.description);

    if (dataState is DataSuccess) {
      emit(UserSelfAddCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(UserSelfAddErrorState(dataState.error!));
    }
  }
}
