import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/translate/locale_keys.dart';
import 'package:linchpin_app/features/root/app_bar_root.dart';
import 'package:linchpin_app/features/time_management/widget/circular_timer.dart';

class TimeManagementScreen extends StatelessWidget {
  const TimeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_LIGHT_COLOR,
      appBar: appBarRoot(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: VERTICAL_SPACING_5x),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigBold(
                  'محمد حسین',
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 4),
                BigRegular(LocaleKeys.goodDay.tr()),
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
