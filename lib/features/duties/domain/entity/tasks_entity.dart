import 'package:equatable/equatable.dart';
import 'package:linchpin/features/duties/data/models/tasks_model/my_task.dart';
import 'package:linchpin/features/duties/data/models/tasks_model/other_task.dart';

class TasksEntity extends Equatable {
  final List<MyTask>? myTasks;
  final List<OtherTask>? otherTasks;

  const TasksEntity({this.myTasks, this.otherTasks});

  @override
  List<Object?> get props => [myTasks, otherTasks];
}
