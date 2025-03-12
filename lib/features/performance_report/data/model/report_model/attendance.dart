import 'package:flutter/foundation.dart';

@immutable
class Attendance {
  final String? date;
  final String? shamsiDate;
  final DateTime? firstCheckIn;
  final DateTime? lastCheckOut;
  final int? workTime;

  const Attendance({
    this.date,
    this.shamsiDate,
    this.firstCheckIn,
    this.lastCheckOut,
    this.workTime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        date: json['date'] as String?,
        shamsiDate: json['shamsiDate'] as String?,
        firstCheckIn: json['firstCheckIn'] == null
            ? null
            : DateTime.parse(json['firstCheckIn'] as String),
        lastCheckOut: json['lastCheckOut'] == null
            ? null
            : DateTime.parse(json['lastCheckOut'] as String),
        workTime: json['workTime'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'shamsiDate': shamsiDate,
        'firstCheckIn': firstCheckIn?.toIso8601String(),
        'lastCheckOut': lastCheckOut?.toIso8601String(),
        'workTime': workTime,
      };
}
