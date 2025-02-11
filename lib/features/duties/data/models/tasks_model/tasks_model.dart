import 'package:flutter/foundation.dart';
import 'package:linchpin_app/features/duties/domain/entity/tasks_entity.dart';

import 'my_task.dart';
import 'other_task.dart';

@immutable
class TasksModel extends TasksEntity {
  const TasksModel({super.myTasks, super.otherTasks});

  factory TasksModel.fromJson(Map<String, dynamic> json) => TasksModel(
        myTasks: (json['myTasks'] as List<dynamic>?)
            ?.map((e) => MyTask.fromJson(e as Map<String, dynamic>))
            .toList(),
        otherTasks: (json['otherTasks'] as List<dynamic>?)
            ?.map((e) => OtherTask.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'myTasks': myTasks?.map((e) => e.toJson()).toList(),
        'otherTasks': otherTasks?.map((e) => e.toJson()).toList(),
      };
}
