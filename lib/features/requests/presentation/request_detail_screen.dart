import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/features/requests/presentation/bloc/requests_bloc.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/box_request_type.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/clock_box.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/explanation_widget.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_date_picker.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
  static ValueNotifier<String?> startDateNotifire = ValueNotifier(null);
  static ValueNotifier<String?> endDateNotifire = ValueNotifier(null);
  static ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  bool isLoading = false;
  @override
  void initState() {
    BoxRequestType.selectedItemNotifire.addListener(checkFormCompletion);
    RequestDetailScreen.startDateNotifire.addListener(checkFormCompletion);
    RequestDetailScreen.endDateNotifire.addListener(checkFormCompletion);
    ClockBox.hourNotifireStrat.addListener(checkFormCompletion);
    ClockBox.minuteNotifireStart.addListener(checkFormCompletion);
    ClockBox.hourNotifireEnd.addListener(checkFormCompletion);
    ClockBox.minuteNotifireEnd.addListener(checkFormCompletion);
    BoxRequestType.selectedItemNotifire.value = null;
    RequestDetailScreen.startDateNotifire.value = null;
    RequestDetailScreen.endDateNotifire.value = null;
    ClockBox.hourNotifireStrat.value = null;
    ClockBox.minuteNotifireStart.value = null;
    BlocProvider.of<RequestsBloc>(context).add(RequestTypesEvent());
    super.initState();
  }

  @override
  void dispose() {
    BoxRequestType.selectedItemNotifire.removeListener(checkFormCompletion);
    RequestDetailScreen.startDateNotifire.removeListener(checkFormCompletion);
    RequestDetailScreen.endDateNotifire.removeListener(checkFormCompletion);
    ClockBox.hourNotifireStrat.removeListener(checkFormCompletion);
    ClockBox.minuteNotifireStart.removeListener(checkFormCompletion);
    ClockBox.hourNotifireEnd.removeListener(checkFormCompletion);
    ClockBox.minuteNotifireEnd.removeListener(checkFormCompletion);
    super.dispose();
  }

  void checkFormCompletion() {
    final type = BoxRequestType.selectedItemNotifire.value;
    final startDate = RequestDetailScreen.startDateNotifire.value;
    final endDate = RequestDetailScreen.endDateNotifire.value;
    final hourStart = ClockBox.hourNotifireStrat.value;
    final minuteStart = ClockBox.minuteNotifireStart.value;
    final hourEnd = ClockBox.hourNotifireEnd.value;
    final minuteEnd = ClockBox.minuteNotifireEnd.value;

    bool isComplete = false;

    switch (type) {
      case 'MANUAL_CHECK_IN':
      case 'MANUAL_CHECK_OUT':
        isComplete =
            startDate != null && hourStart != null && minuteStart != null;
        break;

      case 'HOURLY_LEAVE':
        isComplete = startDate != null &&
            hourStart != null &&
            minuteStart != null &&
            hourEnd != null &&
            minuteEnd != null;
        break;

      case 'SICK_LEAVE':
      case 'DAILY_LEAVE':
        isComplete = startDate != null && endDate != null;
        break;
    }

    RequestDetailScreen.isButtonEnabled.value = isComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: RequestDetailScreen.isButtonEnabled,
        builder: (context, isEnabled, child) {
          return GestureDetector(
            onTap: isEnabled
                ? () {
                    final type = BoxRequestType.selectedItemNotifire.value;
                    final startDate =
                        RequestDetailScreen.startDateNotifire.value;
                    final endDate = RequestDetailScreen.endDateNotifire.value;
                    final description =
                        ExplanationWidget.explanationNotifire.value;

                    String? formatDateTime(
                        String date, String? hour, String? minute) {
                      if (hour == null || minute == null) {
                        return null;
                      }
                      final dateTime = DateTime.parse(date)
                          .toLocal()
                          .copyWith(
                            hour: int.parse(hour),
                            minute: int.parse(minute),
                          )
                          .toUtc();
                      return dateTime.toString().replaceAll(' ', 'T');
                    }

                    void sendRequest(
                        {required String startTime, String? endTime}) {
                      BlocProvider.of<RequestsBloc>(context).add(
                        RequestCreateEvent(
                          type: type!,
                          description: description,
                          startTime: startTime,
                          endTime: endTime,
                        ),
                      );
                    }

                    // بررسی شرایط برای هر نوع درخواست و ارسال آن
                    switch (type) {
                      case 'MANUAL_CHECK_IN':
                      case 'MANUAL_CHECK_OUT':
                        {
                          // بررسی اینکه آیا تاریخ شروع و ساعت ورود پر شده‌اند
                          if (startDate != null &&
                              ClockBox.hourNotifireStrat.value != null &&
                              ClockBox.minuteNotifireStart.value != null) {
                            final startTime = formatDateTime(
                              startDate,
                              ClockBox.hourNotifireStrat.value,
                              ClockBox.minuteNotifireStart.value,
                            );
                            if (startTime != null) {
                              sendRequest(startTime: startTime);
                            }
                          }
                          break;
                        }

                      case 'HOURLY_LEAVE':
                        {
                          // بررسی اینکه تاریخ شروع، ساعت شروع و ساعت پایان پر شده‌اند
                          if (startDate != null &&
                              ClockBox.hourNotifireStrat.value != null &&
                              ClockBox.minuteNotifireStart.value != null &&
                              ClockBox.hourNotifireEnd.value != null &&
                              ClockBox.minuteNotifireEnd.value != null) {
                            final startTime = formatDateTime(
                              startDate,
                              ClockBox.hourNotifireStrat.value,
                              ClockBox.minuteNotifireStart.value,
                            );
                            final endTime = formatDateTime(
                              startDate,
                              ClockBox.hourNotifireEnd.value,
                              ClockBox.minuteNotifireEnd.value,
                            );
                            if (startTime != null && endTime != null) {
                              sendRequest(
                                  startTime: startTime, endTime: endTime);
                            }
                          }
                          break;
                        }

                      case 'SICK_LEAVE':
                      case 'DAILY_LEAVE':
                        {
                          // بررسی اینکه تاریخ شروع و تاریخ پایان پر شده‌اند
                          if (startDate != null && endDate != null) {
                            sendRequest(startTime: startDate, endTime: endDate);
                          }
                          break;
                        }
                    }
                  }
                : null,
            child: Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isEnabled ? Color(0xff861C8C) : Color(0xffCAC4CF),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: NormalMedium(
                'ثبت درخواست',
                textColorInLight: Colors.white,
              ),
            ),
          );
        },
      ),
      body: GestureDetector(
        onTap: () {
          // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<RequestsBloc, RequestsState>(
              listener: (context, state) {
                if (state is RequestCreateCompleted) {
                  Navigator.pop(context, true);
                } else if (state is RequestCreateLoading) {
                  setState(() {
                    isLoading = true;
                  });
                } else if (state is RequestCreateError) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              buildWhen: (previous, current) {
                if (current is RequestTypesCompleted ||
                    current is RequestTypesLoading ||
                    current is RequestTypesError) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is RequestTypesCompleted) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: padding_Horizantalx),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24),
                            BigDemiBold('ثبت درخواست'),
                            SizedBox(height: 24),
                            BoxRequestType(
                              state: state.requestTypesEntity,
                            ),
                            SizedBox(height: 24),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, selectedItem, child) {
                                if (selectedItem == 'MANUAL_CHECK_IN' ||
                                    selectedItem == 'MANUAL_CHECK_OUT' ||
                                    selectedItem == 'HOURLY_LEAVE') {
                                  return ClockBox(
                                    title: selectedItem == 'MANUAL_CHECK_OUT'
                                        ? 'ساعت خروج'
                                        : 'ساعت ورود',
                                    isEndTime: false,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, selectedItem, child) {
                                if (selectedItem == 'HOURLY_LEAVE') {
                                  return Column(
                                    children: [
                                      SizedBox(height: 24),
                                      ClockBox(
                                        title: 'ساعت خروج',
                                        isEndTime: true,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, selectedItem, child) {
                                if (selectedItem == 'MANUAL_CHECK_IN' ||
                                    selectedItem == 'MANUAL_CHECK_OUT' ||
                                    selectedItem == 'HOURLY_LEAVE') {
                                  return PersianDatePicker(
                                    initialDate: DateTime.now(),
                                    onDateSelected: (persianDateSlash,
                                        persianDateHyphen, englishDateIso8601) {
                                      RequestDetailScreen.startDateNotifire
                                          .value = englishDateIso8601;
                                    },
                                    padding:
                                        EdgeInsets.only(bottom: 24, top: 24),
                                    title: 'تاریخ',
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, selectedItem, child) {
                                if (selectedItem == 'DAILY_LEAVE') {
                                  return Column(
                                    children: [
                                      PersianDatePicker(
                                        initialDate: DateTime.now(),
                                        onDateSelected: (persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601) {
                                          RequestDetailScreen.startDateNotifire
                                              .value = englishDateIso8601;
                                        },
                                        padding: EdgeInsets.only(bottom: 24),
                                        title: 'تاریخ شروع',
                                      ),
                                      PersianDatePicker(
                                        initialDate: DateTime.now(),
                                        onDateSelected: (persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601) {
                                          RequestDetailScreen.endDateNotifire
                                              .value = englishDateIso8601;
                                        },
                                        padding: EdgeInsets.only(bottom: 24),
                                        title: 'تاریخ پایان',
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, selectedItem, child) {
                                if (selectedItem == 'SICK_LEAVE') {
                                  return Column(
                                    children: [
                                      PersianDatePicker(
                                        initialDate: DateTime.now(),
                                        onDateSelected: (persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601) {
                                          RequestDetailScreen.startDateNotifire
                                              .value = englishDateIso8601;
                                        },
                                        padding: EdgeInsets.only(bottom: 24),
                                        title: 'تاریخ شروع',
                                      ),
                                      PersianDatePicker(
                                        initialDate: DateTime.now(),
                                        onDateSelected: (persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601) {
                                          RequestDetailScreen.endDateNotifire
                                              .value = englishDateIso8601;
                                        },
                                        padding: EdgeInsets.only(bottom: 24),
                                        title: 'تاریخ پایان',
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  BoxRequestType.selectedItemNotifire,
                              builder: (context, value, child) {
                                if (value != null) {
                                  return ExplanationWidget();
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      if (isLoading)
                        Container(
                          width: context.screenWidth,
                          height: context.screenHeight - 120,
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
                  );
                } else if (state is RequestTypesLoading) {
                  return Container(
                    width: context.screenWidth,
                    height: context.screenHeight - 120,
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
                  );
                } else if (state is RequestTypesError) {
                  return SizedBox(
                      width: context.screenWidth,
                      height: context.screenHeight,
                      child: Center(child: SmallRegular(state.textError)));
                } else {
                  return SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    child: SmallRegular('Technical error'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
