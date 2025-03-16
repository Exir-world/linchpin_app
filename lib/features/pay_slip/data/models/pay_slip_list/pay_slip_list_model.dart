import 'package:flutter/foundation.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pay_slip_list_entity.dart';

@immutable
class PaySlipListModel extends PaySlipListEntity {
  const PaySlipListModel({super.id, super.date, super.paymentDate});

  factory PaySlipListModel.fromJson(Map<String, dynamic> json) =>
      PaySlipListModel(
        id: json['id'] as int?,
        date: json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String),
        paymentDate: json['paymentDate'] == null
            ? null
            : DateTime.parse(json['paymentDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date?.toIso8601String(),
        'paymentDate': paymentDate?.toIso8601String(),
      };
}
