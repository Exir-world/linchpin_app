import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:linchpin_app/core/common/colors.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/snackbar_verify.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/core/translate/locale_keys.dart';
import 'package:linchpin_app/features/root/presentation/root_screen.dart';
import 'package:linchpin_app/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin_app/features/time_management/presentation/widget/circular_timer.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  bool _isLoading = false;

  String? currentStatus;
  String? nameStatus;

  // این موارد فقط برای نمایش در فضای لودینگ دارند استفاده میشن و کاربرد دیگری ندارند
  String? lv;
  String? ls;
  String? lkh;
  String? lN;

  void formatDateTime(DateTime dateTime) {
    // تبدیل تاریخ میلادی به تاریخ شمسی
    Jalali shamsiDate = Jalali.fromDateTime(dateTime);

    // فرمت کردن تاریخ شمسی به صورت "روز ماه" (مثلاً: ۲۲ دی)
    String formattedDate = '${shamsiDate.day} ${shamsiDate.formatter.mN}';

    // شروع تایمر برای به روزرسانی هر ثانیه
    Timer.periodic(Duration(seconds: 1), (timer) {
      // به‌روز رسانی زمان هر ثانیه
      dateTime = dateTime
          .add(Duration(seconds: 1)); // افزایش یک ثانیه به تاریخ و زمان فعلی

      // فرمت کردن زمان (ساعت، دقیقه، ثانیه) از DateTime
      String formattedTime =
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

      // ترکیب تاریخ شمسی و زمان
      RootScreen.timeServerNotofire.value = '$formattedDate | $formattedTime';
    });
  }

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
    currentStatus = null;
    nameStatus = null;
    BlocProvider.of<TimeManagementBloc>(context)
        .add(DailyEvent(actionType: 'daily'));
    formatDateTime(DateTime.now()); // نمایش تاریخ و زمان فرمت‌شده
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimeManagementBloc, TimeManagementState>(
      listener: (context, state) {
        if (state is DailyLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is DailyComplitedState) {
          nameStatus == null
              ? null
              : nameStatus == 'check-in'
                  ? ScaffoldMessenger.of(context).showSnackBar(
                      snackBarVerify(
                        context: context,
                        title: 'ثبت ورود انجام شد.',
                        desc: '',
                      ),
                    )
                  : nameStatus == 'check-out'
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          snackBarVerify(
                            context: context,
                            title: 'خروج شما انجام شد.',
                            desc: '',
                          ),
                        )
                      : nameStatus == 'stop-start'
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              snackBarVerify(
                                context: context,
                                title: 'زمان متوقف شد.',
                                desc: '',
                              ),
                            )
                          : ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarVerify(
                              context: context,
                              title: 'ادامه ساعت کاری فعال شد.',
                              desc: '',
                            ));
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      builder: (context, state) {
        if (state is DailyComplitedState) {
          // فرض میکنیم که workDuration از state به دست میاد
          int workDuration = state.dailyEntity.workDuration ??
              0; // دریافت مدت زمان کاری به ثانیه

          // تبدیل workDuration به فرمت ساعت و دقیقه
          String formattedTime = convertSecondsToTime(workDuration);
          currentStatus = state.dailyEntity.currentStatus;
          lN = state.dailyEntity.user?.name ?? '';
          lkh = state.dailyEntity.lastEndTime;
          ls = formattedTime;
          lv = state.dailyEntity.todayStartTime;
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
                        _truncateText(state.dailyEntity.user?.name ?? '', 10),
                      ),
                    ],
                  ),
                  SizedBox(height: VERTICAL_SPACING_6x),
                  CircularTimer(
                    initTime: currentStatus == 'CHECKED_IN'
                        ? 0
                        : currentStatus == 'STOP'
                            ? 0
                            : null,
                    endTime: state.dailyEntity.eachTimeDuration,
                    openAppTime: state.dailyEntity.currentDuration!,
                    isTimerAllowed: currentStatus == 'STOP' ? false : true,
                    shouldReset: currentStatus ==
                        'CHECKED_OUT', // فقط در صورت "ثبت ورود" ریست شود
                    remainingDuration: state.dailyEntity.remainingDuration!,
                    stopDuration: state.dailyEntity.stopDuration!,
                  ),
                  SizedBox(height: VERTICAL_SPACING_10x),
                  currentStatus == 'CHECKED_OUT'
                      ? ButtonStatus(
                          colorBackgerand: Color(0xff58EC89),
                          title: 'ثبت ورود',
                          icon: Assets.icons.timerTick.svg(),
                          onTap: () {
                            nameStatus = 'check-in';
                            BlocProvider.of<TimeManagementBloc>(context)
                                .add(DailyEvent(actionType: 'check-in'));
                          },
                        )
                      : currentStatus == 'CHECKED_IN'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonStatus(
                                  colorBackgerand: Color(0xffEC5858),
                                  title: 'ثبت خروج',
                                  icon: Assets.icons.timerTick.svg(),
                                  onTap: () {
                                    nameStatus = 'check-out';
                                    BlocProvider.of<TimeManagementBloc>(context)
                                        .add(DailyEvent(
                                            actionType: 'check-out'));
                                  },
                                ),
                                SizedBox(width: 40),
                                ButtonStatus(
                                  colorBackgerand: Color(0xffFFA656),
                                  title: 'توقف',
                                  icon: Assets.icons.pause.svg(),
                                  onTap: () {
                                    nameStatus = 'stop-start';
                                    BlocProvider.of<TimeManagementBloc>(context)
                                        .add(DailyEvent(
                                            actionType: 'stop-start'));
                                  },
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonStatus(
                                  colorBackgerand: Color(0xffEC5858),
                                  title: 'ثبت خروج',
                                  icon: Assets.icons.timerTick.svg(),
                                  onTap: () {
                                    nameStatus = 'check-out';
                                    BlocProvider.of<TimeManagementBloc>(context)
                                        .add(DailyEvent(
                                            actionType: 'check-out'));
                                  },
                                ),
                                SizedBox(width: 40),
                                ButtonStatus(
                                  colorBackgerand: Color(0xff58EC89),
                                  title: 'ادامه',
                                  icon: Assets.icons.play.svg(height: 30),
                                  onTap: () {
                                    nameStatus = 'stop-end';
                                    BlocProvider.of<TimeManagementBloc>(context)
                                        .add(
                                            DailyEvent(actionType: 'stop-end'));
                                  },
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
                        time: formattedTime == '00:00' ? '-' : formattedTime,
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
            backgroundColor: BACKGROUND_LIGHT_COLOR,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: VERTICAL_SPACING_5x),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigRegular(LocaleKeys.goodDay.tr()),
                          SizedBox(width: 4),
                          BigBold(
                            _truncateText(lN ?? '', 10),
                          ),
                        ],
                      ),
                      SizedBox(height: VERTICAL_SPACING_6x),
                      CircularTimer(
                        initTime: null,
                        endTime: null,
                        openAppTime: 0,
                        isTimerAllowed: false,
                        shouldReset: false,
                        remainingDuration: 0,
                        stopDuration: 0,
                      ),
                      SizedBox(height: VERTICAL_SPACING_10x),
                      currentStatus == 'CHECKED_OUT'
                          ? ButtonStatus(
                              colorBackgerand: Color(0xff58EC89),
                              title: 'ثبت ورود',
                              icon: Assets.icons.timerTick.svg(),
                              onTap: () {},
                            )
                          : currentStatus == 'CHECKED_IN'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonStatus(
                                      colorBackgerand: Color(0xffEC5858),
                                      title: 'ثبت خروج',
                                      icon: Assets.icons.timerTick.svg(),
                                      onTap: () {},
                                    ),
                                    SizedBox(width: 40),
                                    ButtonStatus(
                                      colorBackgerand: Color(0xffFFA656),
                                      title: 'توقف',
                                      icon: Assets.icons.pause.svg(),
                                      onTap: () {},
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonStatus(
                                      colorBackgerand: Color(0xffEC5858),
                                      title: 'ثبت خروج',
                                      icon: Assets.icons.timerTick.svg(),
                                      onTap: () {},
                                    ),
                                    SizedBox(width: 40),
                                    ButtonStatus(
                                      colorBackgerand: Color(0xff58EC89),
                                      title: 'ادامه',
                                      icon: Assets.icons.play.svg(height: 30),
                                      onTap: () {},
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
                            time: lv ?? '-',
                          ),
                          SizedBox(width: 12),
                          _BoxEntryExit(
                            image: Assets.icons.timerTick3.svg(),
                            title: 'ساعات کار',
                            time: ls ?? '-',
                          ),
                          SizedBox(width: 12),
                          _BoxEntryExit(
                            image: Assets.icons.timerTick4.svg(),
                            title: 'زمان خروج',
                            time: lkh ?? '-',
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_isLoading)
                    Container(
                      width: context.screenWidth,
                      height: context.screenHeight - 200,
                      color: Colors.white.withValues(alpha: .5),
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SpinKitFadingCube(
                              size: 24,
                              color: Color(0xff670099),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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

class ButtonStatus extends StatelessWidget {
  final Color colorBackgerand;
  final String title;
  final Widget icon;
  final Function() onTap;
  const ButtonStatus({
    super.key,
    required this.colorBackgerand,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: colorBackgerand,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorBackgerand.withValues(alpha: .5),
                    blurRadius: 20.0,
                    offset: Offset(0, 4),
                  ),
                ]),
            alignment: Alignment.center,
            child: icon,
          ),
          SizedBox(height: VERTICAL_SPACING_3x),
          NormalDemiBold(
            title,
            textColorInLight: colorBackgerand,
          ),
        ],
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
