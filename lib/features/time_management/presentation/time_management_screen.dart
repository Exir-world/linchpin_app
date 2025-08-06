import 'package:geolocator/geolocator.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/time_management/presentation/widget/box_entry_exit.dart';
import 'package:linchpin/features/time_management/presentation/widget/button_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:linchpin/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin/features/time_management/presentation/widget/circular_timer.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
  static ValueNotifier<String> nameNotifire =
      ValueNotifier(LocaleKeys.guestUser.tr());
  static ValueNotifier<String> phoneNotifire =
      ValueNotifier(LocaleKeys.withoutNumber.tr());
  static ValueNotifier<double?> latitudeNotifire = ValueNotifier(null);
  static ValueNotifier<double?> longitudeNotifire = ValueNotifier(null);
}

class _TimeManagementScreenState extends State<TimeManagementScreen>
    with WidgetsBindingObserver {
  late TimeManagementBloc _bloc;
  ValueNotifier<bool> isLoadingNotifire = ValueNotifier(false);

  String? currentStatus;
  String? nameStatus;

  void formatDateTime(BuildContext context, DateTime dateTime) {
    String? language = EasyLocalization.of(context)?.locale.languageCode;

    if (language == 'en') {
      // لیست نام ماه‌های میلادی به انگلیسی
      List<String> englishMonths = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];

      // دریافت نام ماه از لیست
      String monthName = englishMonths[dateTime.month - 1];

      // ایجاد فرمت تاریخ مانند "15 March"
      String formattedDate = '${dateTime.day} $monthName';
      RootScreen.timeServerNotofire.value = formattedDate;
    } else if (language == 'ar') {
      // لیست نام ماه‌های میلادی به عربی
      List<String> arabicMonths = [
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر"
      ];

      // دریافت نام ماه از لیست
      String monthName = arabicMonths[dateTime.month - 1];

      // ایجاد فرمت تاریخ مانند "25 مارس"
      String formattedDate = '${dateTime.day} $monthName';
      RootScreen.timeServerNotofire.value = formattedDate;
    } else {
      // تبدیل تاریخ میلادی به تاریخ شمسی
      Jalali shamsiDate = Jalali.fromDateTime(dateTime);

      // فرمت تاریخ شمسی به صورت "روز نام ماه" (مثلاً: ۲۲ دی)
      String formattedDate = '${shamsiDate.day} ${shamsiDate.formatter.mN}';
      RootScreen.timeServerNotofire.value = formattedDate;
    }
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
    WidgetsBinding.instance.addObserver(this);

    _bloc = getIt<TimeManagementBloc>()..add(StartEndWorkEvent());
    currentStatus = null;
    nameStatus = null;
    _bloc.add(DailyEvent(
      actionType: 'daily',
      lat: 0,
      lng: 0,
    ));
    TimeManagementScreen.latitudeNotifire.value = null;
    TimeManagementScreen.longitudeNotifire.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formatDateTime(context, DateTime.now());
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  AppLifecycleState? _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_lastLifecycleState == AppLifecycleState.paused &&
        state == AppLifecycleState.hidden) {
      _bloc.add(DailyEvent(
        actionType: 'daily',
        lat: 0,
        lng: 0,
      ));
      TimeManagementScreen.latitudeNotifire.value = null;
      TimeManagementScreen.longitudeNotifire.value = null;
    }
    _lastLifecycleState = state;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<TimeManagementBloc, TimeManagementState>(
        listener: (context, state) {
          if (state is DailyLoadingState) {
            isLoadingNotifire.value = true;
          } else if (state is DailyComplitedState) {
            TimeManagementScreen.nameNotifire.value =
                state.dailyEntity.user!.name!;
            TimeManagementScreen.phoneNotifire.value =
                state.dailyEntity.user!.phoneNumber!;
            isLoadingNotifire.value = false;
          } else {
            isLoadingNotifire.value = false;
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
            return Scaffold(
              backgroundColor: BACKGROUND_LIGHT_COLOR,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: VERTICAL_SPACING_5x),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BigRegular(LocaleKeys.goodDay.tr()),
                            SizedBox(width: 4),
                            BigBold(
                              _truncateText(
                                  state.dailyEntity.user?.name ?? '', 10),
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
                          isTimerAllowed:
                              currentStatus == 'STOP' ? false : true,
                          shouldReset: currentStatus ==
                              'CHECKED_OUT', // فقط در صورت "ثبت ورود" ریست شود
                          remainingDuration:
                              state.dailyEntity.remainingDuration!,
                          stopDuration: state.dailyEntity.stopDuration!,
                        ),
                        SizedBox(height: VERTICAL_SPACING_10x),
                        currentStatus == 'CHECKED_OUT'
                            ? ButtonStatus(
                                colorBackgerand: Color(0xff58EC89),
                                title: LocaleKeys.entry.tr(),
                                icon: Assets.icons.timerTick.svg(),
                                onTap: () {
                                  if (TimeManagementScreen
                                              .latitudeNotifire.value ==
                                          null ||
                                      TimeManagementScreen
                                              .longitudeNotifire.value ==
                                          null) {
                                    isLoadingNotifire.value = true;
                                    _bloc.add(DailyEvent(
                                      actionType: 'check-in',
                                      lat: AccessLocationScreen
                                              .latitudeNotifire.value ??
                                          0,
                                      lng: AccessLocationScreen
                                              .longitudeNotifire.value ??
                                          0,
                                    ));
                                  } else {
                                    nameStatus = 'check-in';
                                    _bloc.add(DailyEvent(
                                      actionType: 'check-in',
                                      lat: TimeManagementScreen
                                          .latitudeNotifire.value!,
                                      lng: TimeManagementScreen
                                          .longitudeNotifire.value!,
                                    ));
                                  }
                                },
                              )
                            : currentStatus == 'CHECKED_IN'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonStatus(
                                        colorBackgerand: Color(0xffEC5858),
                                        title: LocaleKeys.departure.tr(),
                                        icon: Assets.icons.timerTick.svg(),
                                        onTap: () {
                                          if (TimeManagementScreen
                                                      .latitudeNotifire.value ==
                                                  null ||
                                              TimeManagementScreen
                                                      .longitudeNotifire
                                                      .value ==
                                                  null) {
                                            isLoadingNotifire.value = true;
                                            _bloc.add(DailyEvent(
                                              actionType: 'check-out',
                                              lat: AccessLocationScreen
                                                      .latitudeNotifire.value ??
                                                  0,
                                              lng: AccessLocationScreen
                                                      .longitudeNotifire
                                                      .value ??
                                                  0,
                                            ));
                                          } else {
                                            nameStatus = 'check-out';
                                            _bloc.add(DailyEvent(
                                              actionType: 'check-out',
                                              lat: TimeManagementScreen
                                                  .latitudeNotifire.value!,
                                              lng: TimeManagementScreen
                                                  .longitudeNotifire.value!,
                                            ));
                                          }
                                        },
                                      ),
                                      SizedBox(width: 40),
                                      ButtonStatus(
                                        colorBackgerand: Color(0xffFFA656),
                                        title: LocaleKeys.halt.tr(),
                                        icon: Assets.icons.pause.svg(),
                                        onTap: () {
                                          if (TimeManagementScreen
                                                      .latitudeNotifire.value ==
                                                  null ||
                                              TimeManagementScreen
                                                      .longitudeNotifire
                                                      .value ==
                                                  null) {
                                            isLoadingNotifire.value = true;
                                            _bloc.add(DailyEvent(
                                              actionType: 'stop-start',
                                              lat: AccessLocationScreen
                                                      .latitudeNotifire.value ??
                                                  0,
                                              lng: AccessLocationScreen
                                                      .longitudeNotifire
                                                      .value ??
                                                  0,
                                            ));
                                          } else {
                                            nameStatus = 'stop-start';
                                            _bloc.add(DailyEvent(
                                                actionType: 'stop-start',
                                                lat: TimeManagementScreen
                                                    .latitudeNotifire.value!,
                                                lng: TimeManagementScreen
                                                    .longitudeNotifire.value!));
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonStatus(
                                        colorBackgerand: Color(0xffEC5858),
                                        title: LocaleKeys.departure.tr(),
                                        icon: Assets.icons.timerTick.svg(),
                                        onTap: () {
                                          if (TimeManagementScreen
                                                      .latitudeNotifire.value ==
                                                  null ||
                                              TimeManagementScreen
                                                      .longitudeNotifire
                                                      .value ==
                                                  null) {
                                            isLoadingNotifire.value = true;
                                            _bloc.add(DailyEvent(
                                              actionType: 'check-out',
                                              lat: AccessLocationScreen
                                                      .latitudeNotifire.value ??
                                                  0,
                                              lng: AccessLocationScreen
                                                      .longitudeNotifire
                                                      .value ??
                                                  0,
                                            ));
                                          } else {
                                            nameStatus = 'check-out';
                                            _bloc.add(DailyEvent(
                                                actionType: 'check-out',
                                                lat: TimeManagementScreen
                                                    .latitudeNotifire.value!,
                                                lng: TimeManagementScreen
                                                    .longitudeNotifire.value!));
                                          }
                                        },
                                      ),
                                      SizedBox(width: 40),
                                      ButtonStatus(
                                        colorBackgerand: Color(0xff58EC89),
                                        title: LocaleKeys.continuation.tr(),
                                        icon: Assets.icons.play.svg(height: 30),
                                        onTap: () {
                                          if (TimeManagementScreen
                                                      .latitudeNotifire.value ==
                                                  null ||
                                              TimeManagementScreen
                                                      .longitudeNotifire
                                                      .value ==
                                                  null) {
                                            isLoadingNotifire.value = true;
                                            _bloc.add(DailyEvent(
                                              actionType: 'stop-end',
                                              lat: AccessLocationScreen
                                                      .latitudeNotifire.value ??
                                                  0,
                                              lng: AccessLocationScreen
                                                      .longitudeNotifire
                                                      .value ??
                                                  0,
                                            ));
                                          } else {
                                            nameStatus = 'stop-end';
                                            _bloc.add(DailyEvent(
                                              actionType: 'stop-end',
                                              lat: TimeManagementScreen
                                                  .latitudeNotifire.value!,
                                              lng: TimeManagementScreen
                                                  .longitudeNotifire.value!,
                                            ));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                        SizedBox(height: VERTICAL_SPACING_11x),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BoxEntryExit(
                              image: Assets.icons.timerTick2.svg(),
                              title: LocaleKeys.timeOfEntry.tr(),
                              time: state.dailyEntity.todayStartTime ?? '-',
                            ),
                            SizedBox(width: 12),
                            BoxEntryExit(
                              image: Assets.icons.timerTick3.svg(),
                              title: LocaleKeys.workingHours.tr(),
                              time: formattedTime == '00:00'
                                  ? '-'
                                  : formattedTime,
                            ),
                            SizedBox(width: 12),
                            BoxEntryExit(
                              image: Assets.icons.timerTick4.svg(),
                              title: LocaleKeys.exitTime.tr(),
                              time: state.dailyEntity.lastEndTime ?? '-',
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: isLoadingNotifire,
                          builder: (context, value, child) {
                            return value ? LoadingWidget() : SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DailyLoadingState) {
            return LoadingWidget();
          } else if (state is DailyErrorState) {
            return ErrorUiWidget(
                title: state.errorText,
                onTap: () {
                  getLocation();
                  _bloc
                      .add(DailyEvent(actionType: "daily", lat: 0.0, lng: 0.0));
                });
          } else {
            return Scaffold(
              body: Center(child: NormalMedium('data')),
            );
          }
        },
      ),
    );
  }

  Future<Position?> _getLocationPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> getLocation() async {
    final position = await _getLocationPosition();
    if (!mounted) return;
    if (position == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccessLocationScreen(isFirstApp: false),
        ),
      );
    } else {
      AccessLocationScreen.latitudeNotifire.value = position.latitude;
      AccessLocationScreen.longitudeNotifire.value = position.longitude;
    }
  }
}
