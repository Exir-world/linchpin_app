import 'package:flutter/foundation.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pays_lip_detail_entity.dart';

@immutable
class PaysLipDetailModel extends PayslipDetailEntity {
  const PaysLipDetailModel({
    super.id,
    super.userId,
    super.date,
    super.paymentDate,
    super.standardWorkDays,
    super.netWorkDays,
    super.absentMinutes,
    super.overtimeMinutes,
    super.leaveMinutes,
    super.missionMinutes,
    super.baseSalary,
    super.seniorityPay,
    super.overtimePay,
    super.insuranceFee,
    super.bonus,
    super.totalAmount,
    super.netPayable,
  });

  factory PaysLipDetailModel.fromJson(Map<String, dynamic> json) {
    return PaysLipDetailModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      standardWorkDays: json['standardWorkDays'] as int?,
      netWorkDays: json['netWorkDays'] as int?,
      absentMinutes: json['absentMinutes'] as int?,
      overtimeMinutes: json['overtimeMinutes'] as int?,
      leaveMinutes: json['leaveMinutes'] as int?,
      missionMinutes: json['missionMinutes'] as int?,
      baseSalary: json['baseSalary'] as String?,
      seniorityPay: json['seniorityPay'] as String?,
      overtimePay: json['overtimePay'] as String?,
      insuranceFee: json['insuranceFee'] as String?,
      bonus: json['bonus'] as String?,
      totalAmount: json['totalAmount'] as String?,
      netPayable: json['netPayable'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date?.toIso8601String(),
        'paymentDate': paymentDate?.toIso8601String(),
        'standardWorkDays': standardWorkDays,
        'netWorkDays': netWorkDays,
        'absentMinutes': absentMinutes,
        'overtimeMinutes': overtimeMinutes,
        'leaveMinutes': leaveMinutes,
        'missionMinutes': missionMinutes,
        'baseSalary': baseSalary,
        'seniorityPay': seniorityPay,
        'overtimePay': overtimePay,
        'insuranceFee': insuranceFee,
        'bonus': bonus,
        'totalAmount': totalAmount,
        'netPayable': netPayable,
      };
}
