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
