import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/core/resources/entity/success_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_create_entity.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_types_entity.dart';
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
    on<RequestTypesEvent>(_requestTypesEvent);
    on<RequestCreateEvent>(_requestCreateEvent);
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

  Future<void> _requestTypesEvent(
      RequestTypesEvent event, Emitter<RequestsState> emit) async {
    emit(RequestTypesLoading());

    DataState dataState = await requestUsecase.requestTypes();

    if (dataState is DataSuccess) {
      emit(RequestTypesCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(RequestTypesError(dataState.error!));
    }
  }

  Future<void> _requestCreateEvent(
      RequestCreateEvent event, Emitter<RequestsState> emit) async {
    emit(RequestCreateLoading());

    DataState dataState = await requestUsecase.requestCreate(
        type: event.type,
        description: event.description,
        startTime: event.startTime,
        endTime: event.endTime);

    if (dataState is DataSuccess) {
      emit(RequestCreateCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(RequestCreateError(dataState.error!));
    }
  }
}
