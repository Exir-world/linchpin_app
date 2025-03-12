import 'package:flutter/foundation.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';

@immutable
class MonthsModel extends MonthsEntity {
  const MonthsModel({
    super.startOfMonth,
    super.endOfMonth,
    super.month,
  });

  factory MonthsModel.fromJson(Map<String, dynamic> json) => MonthsModel(
        startOfMonth: json['startOfMonth'] == null
            ? null
            : DateTime.parse(json['startOfMonth'] as String),
        endOfMonth: json['endOfMonth'] == null
            ? null
            : DateTime.parse(json['endOfMonth'] as String),
        month: json['month'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'startOfMonth': startOfMonth,
        'endOfMonth': endOfMonth,
        'month': month,
      };
}
