import 'package:flutter/foundation.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_create_entity.dart';

@immutable
class RequestCreateModel extends RequestCreateEntity {
  const RequestCreateModel({
    super.id,
    super.type,
    super.status,
    super.description,
    super.adminComment,
    super.userId,
    super.startTime,
    super.endTime,
    super.reviewedById,
    super.reviewedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory RequestCreateModel.fromJson(Map<String, dynamic> json) {
    return RequestCreateModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      description: json['description'] as String?,
      adminComment: json['adminComment'] as dynamic,
      userId: json['userId'] as int?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      reviewedById: json['reviewedById'] as dynamic,
      reviewedAt: json['reviewedAt'] as dynamic,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'status': status,
        'description': description,
        'adminComment': adminComment,
        'userId': userId,
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'reviewedById': reviewedById,
        'reviewedAt': reviewedAt,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
