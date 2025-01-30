import 'package:equatable/equatable.dart';

class RequestCreateEntity extends Equatable {
  final int? id;
  final String? type;
  final String? status;
  final String? description;
  final dynamic adminComment;
  final int? userId;
  final DateTime? startTime;
  final DateTime? endTime;
  final dynamic reviewedById;
  final dynamic reviewedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RequestCreateEntity({
    this.id,
    this.type,
    this.status,
    this.description,
    this.adminComment,
    this.userId,
    this.startTime,
    this.endTime,
    this.reviewedById,
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        status,
        description,
        adminComment,
        userId,
        startTime,
        endTime,
        reviewedById,
        reviewedAt,
        createdAt,
        updatedAt,
      ];
}
