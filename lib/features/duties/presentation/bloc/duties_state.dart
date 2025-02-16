part of 'duties_bloc.dart';

sealed class DutiesState {}

final class DutiesInitial extends DutiesState {}

// لیست وظایف خودم و دیگران
final class TasksLoading extends DutiesState {}

final class TasksCompleted extends DutiesState {
  final TasksEntity tasksEntity;

  TasksCompleted(this.tasksEntity);
}

final class TasksError extends DutiesState {
  final String textError;

  TasksError(this.textError);
}

// لیست وظایف خودم و دیگران (همه روزها)
final class AllTasksLoading extends DutiesState {}

final class AllTasksCompleted extends DutiesState {
  final TasksEntity tasksEntity;

  AllTasksCompleted(this.tasksEntity);
}

final class AllTasksError extends DutiesState {
  final String textError;

  AllTasksError(this.textError);
}

// جزئیات درخواست
final class TaskDetailLoading extends DutiesState {}

final class TaskDetailCompleted extends DutiesState {
  final TaskDetailEntity taskDetailEntity;

  TaskDetailCompleted(this.taskDetailEntity);
}

final class TaskDetailError extends DutiesState {
  final String textError;

  TaskDetailError(this.textError);
}

// ساب تسک رو انجام دادم یا ندادم
final class SubtaskDoneLoading extends DutiesState {}

final class SubtaskDoneCompleted extends DutiesState {
  final TaskDetailEntity taskDetailEntity;

  SubtaskDoneCompleted(this.taskDetailEntity);
}

final class SubtaskDoneError extends DutiesState {
  final String textError;

  SubtaskDoneError(this.textError);
}
