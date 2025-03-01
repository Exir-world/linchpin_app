import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/duties/domain/entity/task_detail_entity.dart';
import 'package:linchpin/features/duties/domain/entity/tasks_entity.dart';
import 'package:linchpin/features/duties/domain/use_case/duties_usecase.dart';

part 'duties_event.dart';
part 'duties_state.dart';

@injectable
class DutiesBloc extends Bloc<DutiesEvent, DutiesState> {
  final DutiesUsecase dutiesUsecase;
  DutiesBloc(this.dutiesUsecase) : super(DutiesInitial()) {
    on<TasksEvent>(_tasksEvent);
    on<AllTasksEvent>(_allTasksEvent);
    on<TaskDetailEvent>(_taskDetailEvent);
    on<SubtaskDoneEvent>(_subtaskDoneEvent);
  }
  Future<void> _tasksEvent(TasksEvent event, Emitter<DutiesState> emit) async {
    emit(TasksLoading());

    DataState dataState = await dutiesUsecase.tasks(
        event.startDate, event.endDate, event.priorityId, event.userId);

    if (dataState is DataSuccess) {
      emit(TasksCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(TasksError(dataState.error!));
    }
  }

  Future<void> _allTasksEvent(
      AllTasksEvent event, Emitter<DutiesState> emit) async {
    emit(AllTasksLoading());

    DataState dataState = await dutiesUsecase.allTasks(
        event.startDate, event.endDate, event.priorityId, event.userId);

    if (dataState is DataSuccess) {
      emit(AllTasksCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(AllTasksError(dataState.error!));
    }
  }

  Future<void> _taskDetailEvent(
      TaskDetailEvent event, Emitter<DutiesState> emit) async {
    emit(TaskDetailLoading());

    DataState dataState = await dutiesUsecase.taskDetail(event.taskId);

    if (dataState is DataSuccess) {
      emit(TaskDetailCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(TaskDetailError(dataState.error!));
    }
  }

  Future<void> _subtaskDoneEvent(
      SubtaskDoneEvent event, Emitter<DutiesState> emit) async {
    emit(SubtaskDoneLoading());

    DataState dataState =
        await dutiesUsecase.subtaskDone(event.subtaskId, event.done);

    if (dataState is DataSuccess) {
      emit(SubtaskDoneCompleted(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(SubtaskDoneError(dataState.error!));
    }
  }
}
