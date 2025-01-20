import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/translate/locale_keys.dart';
import 'package:linchpin_app/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin_app/features/time_management/presentation/widget/circular_timer.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  // تعداد کاراکتر های متن اگر بیش از حد مجاز باشه
  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  // تابع برای تبدیل ثانیه‌ها به فرمت ساعت و دقیقه
  String convertSecondsToTime(int seconds) {
    int minutes = seconds ~/ 60; // تبدیل ثانیه‌ها به دقیقه
    int hours = minutes ~/ 60; // استخراج ساعت
    minutes = minutes % 60; // باقی‌مانده دقیقه‌ها
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    BlocProvider.of<TimeManagementBloc>(context).add(DailyEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeManagementBloc, TimeManagementState>(
      builder: (context, state) {
        if (state is DailyComplitedState) {
          // فرض میکنیم که workDuration از state به دست میاد
          int workDuration = state.dailyEntity.workDuration ??
              0; // دریافت مدت زمان کاری به ثانیه

          // تبدیل workDuration به فرمت ساعت و دقیقه
          String formattedTime = convertSecondsToTime(workDuration);
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
                        _truncateText(state.dailyEntity.user!.name!, 10),
                      ),
                    ],
                  ),
                  SizedBox(height: VERTICAL_SPACING_6x),
                  // CircularTimer(
                  //   initTime: DateTime(2025, 01, 8, 13, 00),
                  //   endTime: DateTime(2025, 01, 8, 14, 00),
                  //   openAppTime: DateTime(2025, 01, 8, 13, 50, 23),
                  // ),
                  CircularTimer(
                    initTime: state.dailyEntity.lastStartTime,
                    endTime: state.dailyEntity.endCurrentTime,
                    openAppTime: state.dailyEntity.nowDatetime!,
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
                        time: state.dailyEntity.todayStartTime ?? '-',
                      ),
                      SizedBox(width: 12),
                      _BoxEntryExit(
                        image: Assets.icons.timerTick3.svg(),
                        title: 'ساعات کار',
                        time: formattedTime,
                      ),
                      SizedBox(width: 12),
                      _BoxEntryExit(
                        image: Assets.icons.timerTick4.svg(),
                        title: 'زمان خروج',
                        time: state.dailyEntity.lastEndTime ?? '-',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is DailyLoadingState) {
          return Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        } else if (state is DailyErrorState) {
          return Scaffold(
            body: Center(child: Text(state.errorText)),
          );
        } else {
          return Scaffold(
            body: Center(child: Text('data')),
          );
        }
      },
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
