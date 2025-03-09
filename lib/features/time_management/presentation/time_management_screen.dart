import 'dart:async';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/features/access_location/access_location.dart';
import 'package:linchpin/features/time_management/presentation/widget/box_entry_exit.dart';
import 'package:linchpin/features/time_management/presentation/widget/button_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/colors.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/root/presentation/root_screen.dart';
import 'package:linchpin/features/time_management/presentation/bloc/time_management_bloc.dart';
import 'package:linchpin/features/time_management/presentation/widget/circular_timer.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:geolocator/geolocator.dart';
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
    RootScreen.timeServerNotofire.value = formattedDate;
    // شروع تایمر برای به روزرسانی هر ثانیه
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   // به‌روز رسانی زمان هر ثانیه
    //   dateTime = dateTime
    //       .add(Duration(seconds: 1)); // افزایش یک ثانیه به تاریخ و زمان فعلی

    //   // // فرمت کردن زمان (ساعت، دقیقه، ثانیه) از DateTime
    //   // String formattedTime =
    //   //     '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    //   // ترکیب تاریخ شمسی و زمان
    //   // RootScreen.timeServerNotofire.value = '$formattedDate | $formattedTime';
    //   RootScreen.timeServerNotofire.value = formattedDate;
    // });
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

    _bloc = getIt<TimeManagementBloc>();
    currentStatus = null;
    nameStatus = null;
    _checkAndRequestLocation('daily'); // بررسی و درخواست موقعیت مکانی
    formatDateTime(DateTime.now()); // نمایش تاریخ و زمان فرمت‌شده
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
      // فقط وقتی که از "paused" به "resumed" تغییر کنیم، درخواست ارسال شود
      _checkAndRequestLocation('daily'); // بررسی و درخواست موقعیت مکانی
    }
    _lastLifecycleState = state;
  }

// بررسی و درخواست موقعیت مکانی
  Future<void> _checkAndRequestLocation(String actionType) async {
    try {
      // بررسی روشن بودن GPS فقط اگر actionType "daily" نباشد
      if (actionType != 'daily') {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _navigateToDScreen();
          return;
        }
      }

      // دریافت موقعیت مکانی
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // ارسال اطلاعات لوکیشن به بلاک
      _bloc.add(DailyEvent(
        actionType: actionType,
        lat: actionType == 'daily' ? 0 : position.latitude,
        lng: actionType == 'daily' ? 0 : position.longitude,
      ));

      TimeManagementScreen.latitudeNotifire.value = null;
      TimeManagementScreen.longitudeNotifire.value = null;
    } catch (e) {
      _navigateToDScreen();
    }
  }

// تابعی برای هدایت کاربر به DScreen
  void _navigateToDScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AccessLocationScreen()),
      (Route<dynamic> route) => false,
    );
  }

// دریافت موقعیت و بازنشانی صفحه
  Future<void> _requestLocationAndReload(String actionType) async {
    try {
      _checkAndRequestLocation(actionType);
      // بعد از دریافت لوکیشن، صفحه را ریلود می‌کنیم
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => AuthScreen()),
      // );
    } catch (e) {
      // 🚨 نمایش پیام به کاربر برای فعال کردن GPS
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              NormalMedium("لطفاً GPS را روشن کنید و مجوزهای لازم را بدهید."),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: LocaleKeys.settings.tr(),
            onPressed: () {
              Geolocator.openLocationSettings();
            },
          ),
        ),
      );
    }
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
            // nameStatus == null
            //     ? null
            //     : nameStatus == 'check-in'
            //         ? ScaffoldMessenger.of(context).showSnackBar(
            //             snackBarVerify(
            //               context: context,
            //               title: 'ثبت ورود انجام شد.',
            //               desc: '',
            //               icon: Assets.icons.verify.image(),
            //             ),
            //           )
            //         : nameStatus == 'check-out'
            //             ? ScaffoldMessenger.of(context).showSnackBar(
            //                 snackBarVerify(
            //                   context: context,
            //                   title: 'خروج شما انجام شد.',
            //                   desc: '',
            //                   icon: Assets.icons.verify.image(),
            //                 ),
            //               )
            //             : nameStatus == 'stop-start'
            //                 ? ScaffoldMessenger.of(context).showSnackBar(
            //                     snackBarVerify(
            //                       context: context,
            //                       title: 'زمان متوقف شد.',
            //                       desc: '',
            //                       icon: Assets.icons.verify.image(),
            //                     ),
            //                   )
            //                 : ScaffoldMessenger.of(context)
            //                     .showSnackBar(snackBarVerify(
            //                     context: context,
            //                     title: 'ادامه ساعت کاری فعال شد.',
            //                     desc: '',
            //                     icon: Assets.icons.verify.image(),
            //                   ));

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
            lN = state.dailyEntity.user?.name ?? '';
            lkh = state.dailyEntity.lastEndTime;
            ls = formattedTime;
            lv = state.dailyEntity.todayStartTime;
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
                                    _requestLocationAndReload('check-in');
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
                                            _requestLocationAndReload(
                                                'check-out');
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
                                            _requestLocationAndReload(
                                                'stop-start');
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
                                            _requestLocationAndReload(
                                                'check-out');
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
                                            _requestLocationAndReload(
                                                'stop-end');
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
                        SizedBox(height: VERTICAL_SPACING_8x),
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
                  ValueListenableBuilder(
                    valueListenable: isLoadingNotifire,
                    builder: (context, value, child) {
                      return value ? LoadingWidget() : SizedBox.shrink();
                    },
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
}
