import 'package:flutter/foundation.dart';
import 'package:Linchpin/features/requests/domain/entity/request_types_entity.dart';

@immutable
class RequestTypesModel extends RequestTypesEntity {
  const RequestTypesModel({super.requestId, super.title});

  factory RequestTypesModel.fromJson(Map<String, dynamic> json) {
    return RequestTypesModel(
      requestId: json['requestId'] as String?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'title': title,
      };
}
