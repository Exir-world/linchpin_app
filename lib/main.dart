import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linchpin_app/app_bar_root.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const TimeManagementScreen(),
    );
  }
}

class TimeManagementScreen extends StatelessWidget {
  const TimeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFF),
      appBar: appBarRoot(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'محمدحسین',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff540E5C),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'روز بخیر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff540E5C),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CircularTimer(
              timeStamp: 2000,
              initTime: DateTime(2025, 01, 8, 13, 00),
              endTime: DateTime(2025, 01, 8, 14, 00),
              openAppTime: DateTime(2025, 01, 8, 13, 50, 23),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .7,
            child: CustomPaint(
              painter: SegmentedCircularPainter(
                segments: segments,
                completedSegments: completedSegments,
                getSegmentColor: _getSegmentColor,
                inactiveColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
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
