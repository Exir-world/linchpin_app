import 'package:flutter/foundation.dart';

@immutable
class TaskTag {
  final int? id;
  final String? title;
  final String? color;

  const TaskTag({this.id, this.title, this.color});

  factory TaskTag.fromJson(Map<String, dynamic> json) => TaskTag(
        id: json['id'] as int?,
        title: json['title'] as String?,
        color: json['color'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'color': color,
      };
}
