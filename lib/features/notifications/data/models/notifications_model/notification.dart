import 'package:flutter/foundation.dart';
import 'type_styles.dart';

@immutable
class Notification {
  final int? id;
  final int? userId;
  final String? type;
  final String? title;
  final String? description;
  final bool? read;
  final DateTime? createdAt;
  final TypeStyles? typeStyles;

  const Notification({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.description,
    this.read,
    this.createdAt,
    this.typeStyles,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        type: json['type'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        read: json['read'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        typeStyles: json['typeStyles'] == null
            ? null
            : TypeStyles.fromJson(json['typeStyles'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type,
        'title': title,
        'description': description,
        'read': read,
        'createdAt': createdAt?.toIso8601String(),
        'typeStyles': typeStyles?.toJson(),
      };
}
