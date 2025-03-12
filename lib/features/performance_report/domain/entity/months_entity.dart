import 'package:equatable/equatable.dart';

class MonthsEntity extends Equatable {
  final DateTime? startOfMonth;
  final DateTime? endOfMonth;
  final int? month;

  const MonthsEntity({
    this.startOfMonth,
    this.endOfMonth,
    this.month,
  });

  @override
  List<Object?> get props => [startOfMonth, endOfMonth, month];
}
