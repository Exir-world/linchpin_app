import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/translate/locale_keys.dart';
import 'package:linchpin_app/features/time_management/widget/circular_timer.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class TimeManagementScreen extends StatelessWidget {
  const TimeManagementScreen({super.key});

  // تعداد کاراکتر های متن اگر بیش از حد مجاز باشه
  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_LIGHT_COLOR,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: VERTICAL_SPACING_5x),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigRegular(LocaleKeys.goodDay.tr()),
                SizedBox(width: 4),
                BigBold(
                  _truncateText('محمدحسین', 10),
                ),
              ],
            ),
            SizedBox(height: VERTICAL_SPACING_6x),
            CircularTimer(
              initTime: DateTime(2025, 01, 8, 13, 00),
              endTime: DateTime(2025, 01, 8, 14, 00),
              openAppTime: DateTime(2025, 01, 8, 13, 50, 23),
            ),
            SizedBox(height: VERTICAL_SPACING_10x),
            Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff58EC89),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff58EC89).withValues(alpha: .5),
                          blurRadius: 20.0,
                          offset: Offset(0, 4),
                        ),
                      ]),
                  alignment: Alignment.center,
                  child: Assets.icons.timerTick.svg(),
                ),
                SizedBox(height: VERTICAL_SPACING_3x),
                LargeDemiBold(
                  'ثبت ورود',
                  textColorInLight: Color(0xff58EC89),
                ),
              ],
            ),
            SizedBox(height: VERTICAL_SPACING_8x),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BoxEntryExit(
                  image: Assets.icons.timerTick2.svg(),
                  title: 'زمان ورود',
                  time: '7:45',
                ),
                SizedBox(width: 12),
                _BoxEntryExit(
                  image: Assets.icons.timerTick3.svg(),
                  title: 'ساعات کار',
                  time: '8:15',
                ),
                SizedBox(width: 12),
                _BoxEntryExit(
                  image: Assets.icons.timerTick4.svg(),
                  title: 'زمان خروج',
                  time: '18:00',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BoxEntryExit extends StatelessWidget {
  final Widget image;
  final String title;
  final String time;
  const _BoxEntryExit({
    required this.image,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: Offset(0, 3),
            color: Color(0xff828282).withValues(alpha: .05),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          image,
          SmallMedium(title),
          SmallBold(time),
        ],
      ),
    );
  }
}
