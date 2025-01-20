import 'package:flutter/material.dart';
import 'package:linchpin_app/features/time_management/domain/entity/daily_entity.dart';
import 'user.dart';

@immutable
class DailyModel extends DailyEntity {
  const DailyModel({
    super.nowDatetime,
    super.user,
    super.remainingDuration,
    super.todayStartTime,
    super.lastEndTime,
    super.workDuration,
    super.stopDuration,
    super.currentStatus,
    super.lastStartTime,
    super.initTime,
    super.endTodayTime,
    super.currentDuration,
    super.endCurrentTime,
  });

  factory DailyModel.fromJson(Map<String, dynamic> json) => DailyModel(
        nowDatetime: json['nowDatetime'] == null
            ? null
            : DateTime.parse(json['nowDatetime'] as String),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        remainingDuration: json['remainingDuration'] as int?,
        todayStartTime: json['todayStartTime'] as String?,
        lastEndTime: json['lastEndTime'] as String?,
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
        endCurrentTime: json['endCurrentTime'] == null
            ? null
            : DateTime.parse(json['endCurrentTime'] as String),
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
        'lastStartTime': lastStartTime,
        'initTime': initTime,
        'endTodayTime': endTodayTime?.toIso8601String(),
        'currentDuration': currentDuration,
        'endCurrentTime': endCurrentTime?.toIso8601String(),
      };
}
