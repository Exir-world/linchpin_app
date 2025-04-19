import 'package:flutter/cupertino.dart';
import 'package:linchpin/features/property/domain/entity/my_properties_entity.dart';

import 'property.dart';

@immutable
class MyPropertiesModel extends MyPropertiesEntity {
  const MyPropertiesModel({
    super.id,
    super.userId,
    super.propertyId,
    super.deliveredAt,
    super.property,
  });

  factory MyPropertiesModel.fromJson(Map<String, dynamic> json) {
    return MyPropertiesModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      propertyId: json['propertyId'] as int?,
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      property: json['property'] == null
          ? null
          : Property.fromJson(json['property'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'propertyId': propertyId,
        'deliveredAt': deliveredAt?.toIso8601String(),
        'property': property?.toJson(),
      };
}
