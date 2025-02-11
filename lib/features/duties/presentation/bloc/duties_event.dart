part of 'duties_bloc.dart';

sealed class DutiesEvent {}

// لیست وظایف خودم و دیگران
class TasksEvent extends DutiesEvent {
  final String? startDate;
  final String? endDate;
  final int? priorityId;
  final int? userId;

  TasksEvent({this.startDate, this.endDate, this.priorityId, this.userId});
}

// لیست وظایف خودم و دیگران (همه روزها)
class AllTasksEvent extends DutiesEvent {
  final String? startDate;
  final String? endDate;
  final int? priorityId;
  final int? userId;

  AllTasksEvent({this.startDate, this.endDate, this.priorityId, this.userId});
}
