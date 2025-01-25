import 'package:equatable/equatable.dart';

class MonthsEntity extends Equatable {
  final DateTime? date;
  final int? month;
  final int? workMinutes;
  final int? overDuration;
  final int? lessDuration;
  final int? leaveDuration;

  const MonthsEntity({
    this.date,
    this.month,
    this.workMinutes,
    this.overDuration,
    this.lessDuration,
    this.leaveDuration,
  });

  @override
  List<Object?> get props =>
      [date, month, workMinutes, overDuration, lessDuration, leaveDuration];
}
