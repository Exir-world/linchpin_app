import 'package:equatable/equatable.dart';

class PayslipDetailEntity extends Equatable {
  final int? id;
  final int? userId;
  final DateTime? date;
  final DateTime? paymentDate;
  final int? standardWorkDays;
  final int? netWorkDays;
  final int? absentMinutes;
  final int? overtimeMinutes;
  final int? leaveMinutes;
  final int? missionMinutes;
  final String? baseSalary;
  final String? seniorityPay;
  final String? overtimePay;
  final String? insuranceFee;
  final String? bonus;
  final String? totalAmount;
  final String? netPayable;

  const PayslipDetailEntity({
    this.id,
    this.userId,
    this.date,
    this.paymentDate,
    this.standardWorkDays,
    this.netWorkDays,
    this.absentMinutes,
    this.overtimeMinutes,
    this.leaveMinutes,
    this.missionMinutes,
    this.baseSalary,
    this.seniorityPay,
    this.overtimePay,
    this.insuranceFee,
    this.bonus,
    this.totalAmount,
    this.netPayable,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        paymentDate,
        standardWorkDays,
        netWorkDays,
        absentMinutes,
        overtimeMinutes,
        leaveMinutes,
        missionMinutes,
        baseSalary,
        seniorityPay,
        overtimePay,
        insuranceFee,
        bonus,
        totalAmount,
        netPayable
      ];
}
