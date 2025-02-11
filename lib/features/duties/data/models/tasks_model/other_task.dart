import 'package:flutter/foundation.dart';

import 'priority.dart';
import 'task_tag.dart';
import 'user.dart';

@immutable
class OtherTask {
  final int? id;
  final String? title;
  final String? date;
  final User? user;
  final Priority? priority;
  final bool? done;
  final List<TaskTag>? taskTags;

  const OtherTask({
    this.id,
    this.title,
    this.date,
    this.user,
    this.priority,
    this.done,
    this.taskTags,
  });

  factory OtherTask.fromJson(Map<String, dynamic> json) => OtherTask(
        id: json['id'] as int?,
        title: json['title'] as String?,
        date: json['date'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
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
        'user': user?.toJson(),
        'priority': priority?.toJson(),
        'done': done,
        'taskTags': taskTags?.map((e) => e.toJson()).toList(),
      };
}
