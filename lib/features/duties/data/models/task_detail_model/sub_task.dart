import 'package:flutter/foundation.dart';

@immutable
class SubTask {
  final int? id;
  final String? title;
  final bool? done;

  const SubTask({this.id, this.title, this.done});

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        id: json['id'] as int?,
        title: json['title'] as String?,
        done: json['done'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': done,
      };
}
