import 'package:flutter/foundation.dart';
import 'package:Linchpin/features/duties/data/models/tasks_model/user.dart';
import 'package:Linchpin/features/duties/domain/entity/task_detail_entity.dart';

import 'attachment.dart';
import 'priority.dart';
import 'sub_task.dart';
import 'task_tag.dart';

@immutable
class TaskDetailModel extends TaskDetailEntity {
  const TaskDetailModel({
    super.id,
    super.title,
    super.description,
    super.estimatedDuration,
    super.date,
    super.userId,
    super.createdBy,
    super.creatorApprove,
    super.creatorComment,
    super.createdAt,
    super.priority,
    super.taskTags,
    super.subTasks,
    super.attachments,
    super.user,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      estimatedDuration: json['estimatedDuration'] as dynamic,
      date: json['date'] as String?,
      userId: json['userId'] as int?,
      createdBy: json['createdBy'] as int?,
      creatorApprove: json['creatorApprove'] as bool?,
      creatorComment: json['creatorComment'] as dynamic,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      priority: json['priority'] == null
          ? null
          : Priority.fromJson(json['priority'] as Map<String, dynamic>),
      taskTags: (json['taskTags'] as List<dynamic>?)
          ?.map((e) => TaskTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTasks: (json['subTasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'estimatedDuration': estimatedDuration,
        'date': date,
        'userId': userId,
        'createdBy': createdBy,
        'creatorApprove': creatorApprove,
        'creatorComment': creatorComment,
        'createdAt': createdAt?.toIso8601String(),
        'priority': priority?.toJson(),
        'taskTags': taskTags?.map((e) => e.toJson()).toList(),
        'subTasks': subTasks?.map((e) => e.toJson()).toList(),
        'attachments': attachments?.map((e) => e.toJson()).toList(),
        'user': user?.toJson(),
      };
}
