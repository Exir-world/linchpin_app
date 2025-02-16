import 'package:flutter/foundation.dart';

@immutable
class Priority {
  final int? id;
  final String? title;
  final int? priority;
  final String? color;

  const Priority({this.id, this.title, this.priority, this.color});

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        id: json['id'] as int?,
        title: json['title'] as String?,
        priority: json['priority'] as int?,
        color: json['color'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority,
        'color': color,
      };
}
