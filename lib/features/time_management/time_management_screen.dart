import 'package:flutter/material.dart';
import 'package:linchpin_app/app_bar_root.dart';
import 'package:linchpin_app/features/time_management/widget/circular_timer.dart';

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
