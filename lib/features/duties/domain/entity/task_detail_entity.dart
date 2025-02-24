import 'package:equatable/equatable.dart';
import 'package:Linchpin/features/duties/data/models/task_detail_model/attachment.dart';
import 'package:Linchpin/features/duties/data/models/task_detail_model/priority.dart';
import 'package:Linchpin/features/duties/data/models/task_detail_model/sub_task.dart';
import 'package:Linchpin/features/duties/data/models/task_detail_model/task_tag.dart';
import 'package:Linchpin/features/duties/data/models/tasks_model/user.dart';

class TaskDetailEntity extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final dynamic estimatedDuration;
  final String? date;
  final int? userId;
  final int? createdBy;
  final bool? creatorApprove;
  final dynamic creatorComment;
  final DateTime? createdAt;
  final Priority? priority;
  final List<TaskTag>? taskTags;
  final List<SubTask>? subTasks;
  final List<Attachment>? attachments;
  final User? user;

  const TaskDetailEntity({
    this.id,
    this.title,
    this.description,
    this.estimatedDuration,
    this.date,
    this.userId,
    this.createdBy,
    this.creatorApprove,
    this.creatorComment,
    this.createdAt,
    this.priority,
    this.taskTags,
    this.subTasks,
    this.attachments,
    this.user,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        estimatedDuration,
        date,
        userId,
        createdBy,
        creatorApprove,
        creatorComment,
        createdAt,
        priority,
        taskTags,
        subTasks,
        attachments,
        user,
      ];
}
