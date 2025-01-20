import 'package:equatable/equatable.dart';
import 'package:linchpin_app/features/time_management/data/models/daily_model/user.dart';

class DailyEntity extends Equatable {
  final DateTime? nowDatetime; // تایم فعلی سرور
  final User? user; // اطلاعات کاربر
  final int? remainingDuration; // تایم باقی مانده کل روز
  final String? todayStartTime; // اولین ورود روز (نمایشی هست فقط)
  final String? lastEndTime; // آخرین خروجی که کاربر ثبت کرده
  final int? workDuration; // میزان کارکرد روز (یعنی تا الان چند ساعت کار کرده)
  final int? stopDuration; // میزان توقف آن ساعت
  final String? currentStatus; // وضعیت ورود و خروج
  final DateTime?
      lastStartTime; // آخرین ورودی که کاربر ثبت کرده (شروع شیفت کرنومتر)
  final DateTime? initTime; // اولین ورود روز
  final DateTime? endTodayTime; // آخرین ساعتی که باید از شرکت خارج بشه
  final int?
      currentDuration; // میزان کارکردش واسه تایم فعلی (زمانی که کاربر پشت سر گذاشته در کرنومتر)
  final DateTime?
      endCurrentTime; // آخرین ساعتی که کاربر در اون شیفت باید خارج بشه

  const DailyEntity({
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
    this.endCurrentTime,
  });

  @override
  List<Object?> get props => [
        nowDatetime,
        user,
        remainingDuration,
        todayStartTime,
        lastEndTime,
        workDuration,
        stopDuration,
        currentStatus,
        lastStartTime,
        initTime,
        endTodayTime,
        currentDuration,
        endCurrentTime,
      ];
}
