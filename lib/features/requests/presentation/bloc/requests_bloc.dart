import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_user_entity.dart';
import 'package:linchpin_app/features/requests/domain/usecase/request_usecase.dart';

part 'requests_event.dart';
part 'requests_state.dart';

@injectable
class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final RequestUsecase requestUsecase;
  RequestsBloc(this.requestUsecase) : super(RequestsLoading()) {
    on<RequestUser>(_requestUser);
    on<RequestCancelEvent>(_requestCancelEvent);
  }

  Future<void> _requestUser(
      RequestsEvent event, Emitter<RequestsState> emit) async {
    emit(RequestsLoading());

    DataState dataState = await requestUsecase.requestsUser();

    if (dataState is DataSuccess) {
      emit(RequestsCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(RequestsError(dataState.error!));
    }
  }

  Future<void> _requestCancelEvent(
      RequestCancelEvent event, Emitter<RequestsState> emit) async {
    emit(RequestsLoading());

    DataState dataState = await requestUsecase.requestCancel(event.id);

    if (dataState is DataSuccess) {
      emit(RequestCancelCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(RequestCancelError(dataState.error!));
    }
  }
}
