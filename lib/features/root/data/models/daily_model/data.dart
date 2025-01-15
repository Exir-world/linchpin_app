import 'package:flutter/foundation.dart';

import 'user.dart';

@immutable
class Data {
  final DateTime? nowDatetime;
  final User? user;
  final int? remainingDuration;
  final String? todayStartTime;
  final dynamic lastEndTime;
  final int? workDuration;
  final int? stopDuration;
  final String? currentStatus;
  final DateTime? lastStartTime;
  final DateTime? initTime;
  final DateTime? endTodayTime;
  final int? currentDuration;

  const Data({
    this.nowDatetime,
    this.user,
    this.remainingDuration,
    this.todayStartTime,
    this.lastEndTime,
    this.workDuration,
    this.stopDuration,
    this.currentStatus,
    this.lastStartTime,
    this.initTime,
    this.endTodayTime,
    this.currentDuration,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        nowDatetime: json['nowDatetime'] == null
            ? null
            : DateTime.parse(json['nowDatetime'] as String),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        remainingDuration: json['remainingDuration'] as int?,
        todayStartTime: json['todayStartTime'] as String?,
        lastEndTime: json['lastEndTime'] as dynamic,
        workDuration: json['workDuration'] as int?,
        stopDuration: json['stopDuration'] as int?,
        currentStatus: json['currentStatus'] as String?,
        lastStartTime: json['lastStartTime'] == null
            ? null
            : DateTime.parse(json['lastStartTime'] as String),
        initTime: json['initTime'] == null
            ? null
            : DateTime.parse(json['initTime'] as String),
        endTodayTime: json['endTodayTime'] == null
            ? null
            : DateTime.parse(json['endTodayTime'] as String),
        currentDuration: json['currentDuration'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'nowDatetime': nowDatetime?.toIso8601String(),
        'user': user?.toJson(),
        'remainingDuration': remainingDuration,
        'todayStartTime': todayStartTime,
        'lastEndTime': lastEndTime,
        'workDuration': workDuration,
        'stopDuration': stopDuration,
        'currentStatus': currentStatus,
        'lastStartTime': lastStartTime?.toIso8601String(),
        'initTime': initTime?.toIso8601String(),
        'endTodayTime': endTodayTime?.toIso8601String(),
        'currentDuration': currentDuration,
      };
}
