import 'package:flutter/foundation.dart';

@immutable
class Attendance {
  final DateTime? checkIn;
  final DateTime? checkOut;

  const Attendance({this.checkIn, this.checkOut});

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        checkIn: json['checkIn'] == null
            ? null
            : DateTime.parse(json['checkIn'] as String),
        checkOut: json['checkOut'] == null
            ? null
            : DateTime.parse(json['checkOut'] as String),
      );

  Map<String, dynamic> toJson() => {
        'checkIn': checkIn?.toIso8601String(),
        'checkOut': checkOut?.toIso8601String(),
      };
}
