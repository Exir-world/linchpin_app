import 'dart:async';

import 'package:flutter/material.dart';

class CircularTimer extends StatefulWidget {
  final DateTime initTime; // The first log of the day
  final DateTime endTime; // The last output that the user must register
  final DateTime openAppTime; // Current server time
  final int timeStamp;

  const CircularTimer({
    super.key,
    required this.timeStamp,
    required this.initTime,
    required this.endTime,
    required this.openAppTime,
  });

  @override
  State<StatefulWidget> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  int completedSegments = 0; // تعداد segments تکمیل‌شده
  final int segments = 60; // تعداد segments در دایره
  late Timer _timer; // تایمر برای به روز رسانی زمان
  late DateTime currentTime; // متغیر جدید برای ذخیره زمان جاری
  late int secondsPerSegment; // تعداد ثانیه‌هایی که یک سگمنت را پر می‌کند

  // رنگ‌های شروع، وسط و پایان برای گرادینت سه رنگ
  final Color activeColorStart = Color(0xff9642E5); // رنگ شروع
  final Color activeColorMiddle = Color(0xffC81ED1); // رنگ وسط
  final Color activeColorEnd = Color(0xff670F6B); // رنگ پایان

  @override
  void initState() {
    super.initState();
    currentTime = widget.openAppTime; // مقدار اولیه زمان جاری
    secondsPerSegment =
        (widget.endTime.difference(widget.initTime).inSeconds / segments)
            .round();
    _calculateCompletedSegments();
    _startTimer();
  }

  // تایمر را برای به روز رسانی openAppTime هر ثانیه شروع می کنیم
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTime.isBefore(widget.endTime)) {
        setState(() {
          currentTime =
              currentTime.add(Duration(seconds: 1)); // افزایش زمان جاری
          _calculateCompletedSegments(); // محاسبه تعداد segments
        });
      } else {
        _timer.cancel(); // وقتی به endTime رسیدیم، تایمر متوقف می‌شود
      }
    });
  }

  // محاسبه تعداد segments پرشده بر اساس زمان جاری
  void _calculateCompletedSegments() {
    int elapsedTimeInSeconds =
        currentTime.difference(widget.initTime).inSeconds;

    // محاسبه تعداد segments بر اساس تعداد ثانیه‌هایی که گذشت
    setState(() {
      completedSegments = (elapsedTimeInSeconds / secondsPerSegment).round();
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
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Container(
            color: Colors.red,
            child: CustomPaint(
              painter: SegmentedCircularPainter(
                segments: segments,
                completedSegments: completedSegments,
                getSegmentColor: _getSegmentColor,
                inactiveColor: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('صدا: روشن'),
                  SizedBox(width: 5),
                  Icon(Icons.notifications_active_outlined),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '۰۰:۰۰:۰۰',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 54,
                  color: Color(0xff861C8C),
                ),
              ),
              Text('8 ساعت باقی مانده'),
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
