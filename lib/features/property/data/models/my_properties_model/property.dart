import 'package:flutter/cupertino.dart';

@immutable
class Property {
  final int? id;
  final String? title;
  final String? code;
  final String? status;
  final DateTime? createdAt;
  final int? organizationId;
  final int? departmentId;
  final String? imageUrl;

  const Property({
    this.id,
    this.title,
    this.code,
    this.status,
    this.createdAt,
    this.organizationId,
    this.departmentId,
    this.imageUrl,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json['id'] as int?,
        title: json['title'] as String?,
        code: json['code'] as String?,
        status: json['status'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        organizationId: json['organizationId'] as int?,
        departmentId: json['departmentId'] as int?,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'organizationId': organizationId,
        'departmentId': departmentId,
        'imageUrl': imageUrl,
      };
}
