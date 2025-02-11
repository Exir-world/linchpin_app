import 'package:flutter/foundation.dart';

import 'priority.dart';
import 'task_tag.dart';

@immutable
class MyTask {
  final int? id;
  final String? title;
  final String? date;
  final Priority? priority;
  final bool? done;
  final List<TaskTag>? taskTags;

  const MyTask({
    this.id,
    this.title,
    this.date,
    this.priority,
    this.done,
    this.taskTags,
  });

  factory MyTask.fromJson(Map<String, dynamic> json) => MyTask(
        id: json['id'] as int?,
        title: json['title'] as String?,
        date: json['date'] as String?,
        priority: json['priority'] == null
            ? null
            : Priority.fromJson(json['priority'] as Map<String, dynamic>),
        done: json['done'] as bool?,
        taskTags: (json['taskTags'] as List<dynamic>?)
            ?.map((e) => TaskTag.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'priority': priority?.toJson(),
        'done': done,
        'taskTags': taskTags?.map((e) => e.toJson()).toList(),
      };
}
