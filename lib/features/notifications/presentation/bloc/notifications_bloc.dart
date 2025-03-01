import 'dart:async';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/resources/entity/success_entity.dart';
import 'package:linchpin/features/notifications/domain/entity/notifications_entity.dart';
import 'package:linchpin/features/notifications/domain/use_case/notifications_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsUsecase notificationsUsecase;
  NotificationsBloc(this.notificationsUsecase) : super(NotificationsInitial()) {
    on<NotificationListEvent>(_notificationListEvent);
    on<MarkAsReadEvent>(_markAsReadEvent);
  }

  FutureOr<void> _notificationListEvent(
      NotificationListEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationListLoadingState());
    DataState dataState = await notificationsUsecase.notifications();

    if (dataState is DataSuccess) {
      emit(NotificationListCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(NotificationListErrorState(dataState.error!));
    }
  }

  FutureOr<void> _markAsReadEvent(
      MarkAsReadEvent event, Emitter<NotificationsState> emit) async {
    emit(MarkAsReadLoadingState());
    DataState dataState = await notificationsUsecase.markAsRead(event.notifId);

    if (dataState is DataSuccess) {
      emit(MarkAsReadCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(MarkAsReadErrorState(dataState.error!));
    }
  }
}
