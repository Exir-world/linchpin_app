import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class CircularTimer extends StatefulWidget {
  final int? initTime; // مقدار زمان شروع (TimeStamp بر حسب میلی‌ثانیه)
  final int? endTime; // مقدار زمان پایان (TimeStamp بر حسب میلی‌ثانیه)
  final int openAppTime; // مقدار زمان فعلی (TimeStamp بر حسب میلی‌ثانیه)
  final bool isTimerAllowed; // مقدار بولین برای کنترل تایمر
  final bool shouldReset; // مقدار بولین برای ریست تایمر
  final int remainingDuration; // زمان باقی‌مانده بر حسب ثانیه
  final int stopDuration; // زمان توقفی که کاربر کرده بر حسب ثانیه

  const CircularTimer({
    super.key,
    required this.initTime,
    required this.endTime,
    required this.openAppTime,
    required this.isTimerAllowed,
    required this.shouldReset,
    required this.remainingDuration,
    required this.stopDuration,
  });

  @override
  State<StatefulWidget> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  int completedSegments = 0; // تعداد segments تکمیل‌شده
  final int segments = 60; // تعداد segments در دایره
  late Timer _timer =
      Timer(Duration.zero, () {}); // تایمر برای به روز رسانی زمان
  late Duration elapsedDuration; // مدت زمانی که از initTime گذشته
  bool isTimerRunning = false; // وضعیت کرنومتر
  late int secondsPerSegment; // تعداد ثانیه‌هایی که یک سگمنت را پر می‌کند
  late int remainingTime; // زمان باقی‌مانده (بر حسب ثانیه)
  late int stopDuration; // زمان توقفی که کاربر کرده بر حسب ثانیه

  // رنگ‌های شروع، وسط و پایان برای گرادینت سه رنگ
  final Color activeColorStart = Color(0xff9642E5); // رنگ شروع
  final Color activeColorMiddle = Color(0xffC81ED1); // رنگ وسط
  final Color activeColorEnd = Color(0xff670F6B); // رنگ پایان

  @override
  void initState() {
    super.initState();

    // تنظیم مقدار اولیه remainingTime
    remainingTime = widget.remainingDuration;
    stopDuration = widget.stopDuration;

    if (widget.initTime != null && widget.endTime != null) {
      // تعداد میلی‌ثانیه‌ها برای هر سگمنت
      secondsPerSegment =
          ((widget.endTime! - widget.initTime!) / segments).round();

      // محاسبه مدت زمان سپری شده از initTime
      elapsedDuration = Duration(
        seconds: widget.openAppTime - widget.initTime!,
      );

      _calculateCompletedSegments();
      _startTimer();
      // شروع تایمر مستقل برای کاهش زمان باقی‌مانده
      _startRemainingTimeTimer();

      if (!widget.isTimerAllowed) {
        _startStopDurationTimer();
      }
    } else {
      elapsedDuration = Duration.zero;
    }
  }

  // تایمر کاهش زمان باقی‌مانده
  void _startRemainingTimeTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel(); // اگر زمان باقی‌مانده تمام شد، تایمر را متوقف کن
      }
    });
  }

  // تایمر افزایش زمان توقف
  void _startStopDurationTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        stopDuration++;
      });
    });
  }

  // فرمت نمایش زمان باقی‌مانده
  String _formatRemainingTime(int remainingSeconds) {
    int totalMinutes = remainingSeconds ~/ 60;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours ساعت، $minutes دقیقه';
    } else {
      return '$minutes دقیقه';
    }
  }

  // فرمت نمایش زمان توقف
  String _formatStopDurationTime(int remainingSeconds) {
    int totalMinutes = remainingSeconds ~/ 60;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    int seconds = remainingSeconds % 60;

    if (remainingSeconds < 60) {
      return '$seconds ثانیه';
    } else if (hours > 0) {
      return '$hours ساعت، $minutes دقیقه';
    } else {
      return '$minutes دقیقه';
    }
  }

  // تایمر را برای به روز رسانی openAppTime هر ثانیه شروع می کنیم
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!widget.isTimerAllowed) {
        return; // اگر اجازه داده نشده، از ادامه جلوگیری می‌کنیم
      }

      setState(() {
        elapsedDuration += Duration(seconds: 1);
        _calculateCompletedSegments();
      });

      // بررسی اتمام تایمر بر اساس مقدار میلی‌ثانیه‌ها
      // if (elapsedDuration.inSeconds >= (widget.endTime! - widget.initTime!)) {
      //   _timer.cancel();
      // }
    });
  }

  void _resetTimer() {
    setState(() {
      _timer.cancel();
      elapsedDuration = Duration.zero;
      completedSegments = 0;
      if (widget.isTimerAllowed) {
        _startTimer();
      }
    });
  }

  @override
  void didUpdateWidget(CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // بررسی تغییر در isTimerAllowed
    if (oldWidget.isTimerAllowed != widget.isTimerAllowed) {
      if (widget.isTimerAllowed) {
        _startTimer();
      } else {
        _timer.cancel();
      }
    }

    // بررسی تغییر در shouldReset
    if (widget.shouldReset && !oldWidget.shouldReset) {
      _resetTimer();
      // اینجا می‌توانید از یک callback یا مدیریت وضعیت برای بازگرداندن مقدار shouldReset به false استفاده کنید.
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // محاسبه تعداد segments پرشده بر اساس زمان جاری
  void _calculateCompletedSegments() {
    setState(() {
      completedSegments =
          (elapsedDuration.inSeconds / secondsPerSegment).round();
      if (completedSegments > segments) {
        completedSegments = segments; // جلوگیری از پر شدن بیش از حد دایره
      }
    });
  }

  // تابعی برای محاسبه رنگ هر سگمنت از سه رنگ
  Color _getSegmentColor(int index) {
    double progress = index / (segments - 1);
    // استفاده از lerp برای ایجاد تغییرات رنگی بین سه رنگ

    if (progress < 0.5) {
      return Color.lerp(activeColorStart, activeColorMiddle, progress * 2)!;
    } else {
      return Color.lerp(
          activeColorMiddle, activeColorEnd, (progress - 0.5) * 2)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter, // مرکز چین کردن تمام ویجت‌های داخل Stack
      children: [
        SizedBox(
          width: context.screenWidth * 0.7,
          child: CustomPaint(
            painter: SegmentedCircularPainter(
              segments: segments,
              completedSegments: completedSegments,
              getSegmentColor: _getSegmentColor,
              inactiveColor: Colors.grey.shade300,
            ),
          ),
        ),
        SizedBox(
          height: context.screenWidth * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.icons.ringing.svg(),
                  SizedBox(width: 5),
                  NormalRegular('صدا: روشن'),
                ],
              ),
              SizedBox(height: 8),
              MegaBold(
                _formatDuration(elapsedDuration), // به جای مقدار ثابت
                textColorInLight: TEXT_LIGHT_CHRONOMETER_COLOR,
              ),
              NormalRegular(
                  '${_formatRemainingTime(remainingTime)} باقی مانده'),
              !widget.isTimerAllowed ? SizedBox(height: 12) : Container(),
              !widget.isTimerAllowed
                  ? SmallRegular(
                      _formatStopDurationTime(stopDuration),
                      textColorInLight: Color(0xffFF912E),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // متوقف کردن تایمر هنگام بسته شدن ویجت
    super.dispose();
  }
}

class SegmentedCircularPainter extends CustomPainter {
  final int segments;
  final int completedSegments;
  final Color inactiveColor;
  final Color Function(int) getSegmentColor;

  SegmentedCircularPainter({
    required this.segments,
    required this.completedSegments,
    required this.getSegmentColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final double radius = size.width / 2;
    final double segmentAngle = 2 * 3.14159 / segments;

    for (int i = 0; i < segments; i++) {
      // اگر سگمنت فعال باشد، رنگ مربوطه را با استفاده از getSegmentColor می‌گیریم
      paint.color = i < completedSegments ? getSegmentColor(i) : inactiveColor;

      final double startAngle = i * segmentAngle - 3.14159 / 2;
      final double sweepAngle = segmentAngle * 0.4; // فاصله جزئی بین segments

      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
