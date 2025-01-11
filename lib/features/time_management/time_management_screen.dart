import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/root/app_bar_root.dart';
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
            SizedBox(height: VERTICAL_SPACING_5x),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigBold('محمدحسین'),
                SizedBox(width: 4),
                BigRegular('روز بخیر'),
              ],
            ),
            SizedBox(height: VERTICAL_SPACING_6x),
            CircularTimer(
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
