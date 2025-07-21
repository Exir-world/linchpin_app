import 'package:equatable/equatable.dart';
import 'package:linchpin/features/property/data/models/my_properties_model/property.dart';

class MyPropertiesEntity extends Equatable {
  final int? id;
  final int? userId;
  final int? propertyId;
  final DateTime? deliveredAt;
  final Property? property;

  const MyPropertiesEntity({
    this.id,
    this.userId,
    this.propertyId,
    this.deliveredAt,
    this.property,
  });

  @override
  List<Object?> get props => [id, userId, propertyId, deliveredAt, property];
}
