import 'package:equatable/equatable.dart';

class PaySlipListEntity extends Equatable {
  final int? id;
  final DateTime? date;
  final DateTime? paymentDate;

  const PaySlipListEntity({this.id, this.date, this.paymentDate});

  @override
  List<Object?> get props => [id, date, paymentDate];
}
