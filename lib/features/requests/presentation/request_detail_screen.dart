import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/features/requests/presentation/bloc/requests_bloc.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/box_request_type.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/clock_box.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/explanation_widget.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
  static ValueNotifier<String?> startDateNotifire = ValueNotifier(null);
  static ValueNotifier<String?> endDateNotifire = ValueNotifier(null);
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    BoxRequestType.selectedItemNotifire.value = null;
    RequestDetailScreen.startDateNotifire.value = null;
    RequestDetailScreen.endDateNotifire.value = null;
    ClockBox.hourNotifireStrat.value = null;
    ClockBox.minuteNotifireStart.value = null;
    BlocProvider.of<RequestsBloc>(context).add(RequestTypesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          if (BoxRequestType.selectedItemNotifire.value != null &&
              RequestDetailScreen.startDateNotifire.value != null) {
            if (BoxRequestType.selectedItemNotifire.value ==
                    'MANUAL_CHECK_IN' &&
                ClockBox.hourNotifireStrat.value != null &&
                ClockBox.minuteNotifireStart.value != null) {
              String hour = ClockBox.hourNotifireStrat.value!;
              String minute = ClockBox.minuteNotifireStart.value!;

              // تاریخ اولیه
              String date = RequestDetailScreen.startDateNotifire.value!;

              DateTime dateTime1 = DateTime.parse(date).toLocal();
              DateTime updatedDate1 = dateTime1
                  .copyWith(
                    hour: int.parse(hour),
                    minute: int.parse(minute),
                  )
                  .toUtc();
              // فرمت خروجی را بازسازی می‌کنیم تا `T` باقی بماند
              String formattedDate =
                  updatedDate1.toString().replaceAll(' ', 'T');
              // اگر تردد دستی ورود بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: formattedDate,
                ),
              );
            } else if (BoxRequestType.selectedItemNotifire.value ==
                    'MANUAL_CHECK_OUT' &&
                ClockBox.hourNotifireStrat.value != null &&
                ClockBox.minuteNotifireStart.value != null) {
              String hour = ClockBox.hourNotifireStrat.value!;
              String minute = ClockBox.minuteNotifireStart.value!;

              // تاریخ اولیه
              String date = RequestDetailScreen.startDateNotifire.value!;

              DateTime dateTime1 = DateTime.parse(date).toLocal();
              DateTime updatedDate1 = dateTime1
                  .copyWith(
                    hour: int.parse(hour),
                    minute: int.parse(minute),
                  )
                  .toUtc();
              // فرمت خروجی را بازسازی می‌کنیم تا `T` باقی بماند
              String formattedDate =
                  updatedDate1.toString().replaceAll(' ', 'T');

              // اگر تردد دستی خروج بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: formattedDate,
                ),
              );
            } else if (BoxRequestType.selectedItemNotifire.value ==
                    'HOURLY_LEAVE' &&
                ClockBox.hourNotifireStrat.value != null &&
                ClockBox.minuteNotifireStart.value != null &&
                ClockBox.hourNotifireEnd.value != null &&
                ClockBox.minuteNotifireEnd.value != null) {
              String hourStart = ClockBox.hourNotifireStrat.value!;
              String minuteStart = ClockBox.minuteNotifireStart.value!;
              String hourEnd = ClockBox.hourNotifireEnd.value!;
              String minuteEnd = ClockBox.minuteNotifireEnd.value!;

              // تاریخ اولیه
              String date = RequestDetailScreen.startDateNotifire.value!;

              DateTime dateTime1 = DateTime.parse(date).toLocal();
              DateTime updatedDate1 = dateTime1
                  .copyWith(
                    hour: int.parse(hourStart),
                    minute: int.parse(minuteStart),
                  )
                  .toUtc();
              // فرمت خروجی را بازسازی می‌کنیم تا `T` باقی بماند
              String formattedDateStart =
                  updatedDate1.toString().replaceAll(' ', 'T');

              DateTime dateTime2 = DateTime.parse(date).toLocal();
              DateTime updatedDate2 = dateTime2
                  .copyWith(
                    hour: int.parse(hourEnd),
                    minute: int.parse(minuteEnd),
                  )
                  .toUtc();
              // فرمت خروجی را بازسازی می‌کنیم تا `T` باقی بماند
              String formattedDateEnd =
                  updatedDate2.toString().replaceAll(' ', 'T');
              // اگر مرخصی ساعتی بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: formattedDateStart,
                  endTime: formattedDateEnd,
                ),
              );
            } else if (BoxRequestType.selectedItemNotifire.value ==
                    'SICK_LEAVE' &&
                RequestDetailScreen.startDateNotifire.value != null &&
                RequestDetailScreen.endDateNotifire.value != null) {
              // اگر مرخصی استعلاجی بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: RequestDetailScreen.startDateNotifire.value!,
                  endTime: RequestDetailScreen.endDateNotifire.value,
                ),
              );
            } else if (BoxRequestType.selectedItemNotifire.value ==
                    'DAILY_LEAVE' &&
                RequestDetailScreen.startDateNotifire.value != null &&
                RequestDetailScreen.endDateNotifire.value != null) {
              // اگر مرخصی روزانه بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: RequestDetailScreen.startDateNotifire.value!,
                  endTime: RequestDetailScreen.endDateNotifire.value,
                ),
              );
            }
          }
        },
        child: Container(
          height: 56,
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Color(0xff861C8C),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: NormalMedium(
            'ثبت درخواست',
            textColorInLight: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocBuilder<RequestsBloc, RequestsState>(
              builder: (context, state) {
                if (state is RequestTypesCompleted) {
                  return Padding(
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
                          valueListenable: BoxRequestType.selectedItemNotifire,
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
                          valueListenable: BoxRequestType.selectedItemNotifire,
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
                          valueListenable: BoxRequestType.selectedItemNotifire,
                          builder: (context, selectedItem, child) {
                            if (selectedItem == 'MANUAL_CHECK_IN' ||
                                selectedItem == 'MANUAL_CHECK_OUT' ||
                                selectedItem == 'HOURLY_LEAVE') {
                              return PersianDatePicker(
                                initialDate: DateTime.now(),
                                onDateSelected: (persianDateSlash,
                                    persianDateHyphen, englishDateIso8601) {
                                  RequestDetailScreen.startDateNotifire.value =
                                      englishDateIso8601;
                                },
                                padding: EdgeInsets.only(bottom: 24, top: 24),
                                title: 'تاریخ',
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: BoxRequestType.selectedItemNotifire,
                          builder: (context, selectedItem, child) {
                            if (selectedItem == 'DAILY_LEAVE') {
                              return Column(
                                children: [
                                  PersianDatePicker(
                                    initialDate: DateTime.now(),
                                    onDateSelected: (persianDateSlash,
                                        persianDateHyphen, englishDateIso8601) {
                                      RequestDetailScreen.startDateNotifire
                                          .value = englishDateIso8601;
                                    },
                                    padding: EdgeInsets.only(bottom: 24),
                                    title: 'تاریخ شروع',
                                  ),
                                  PersianDatePicker(
                                    initialDate: DateTime.now(),
                                    onDateSelected: (persianDateSlash,
                                        persianDateHyphen, englishDateIso8601) {
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
                          valueListenable: BoxRequestType.selectedItemNotifire,
                          builder: (context, selectedItem, child) {
                            if (selectedItem == 'SICK_LEAVE') {
                              return Column(
                                children: [
                                  PersianDatePicker(
                                    initialDate: DateTime.now(),
                                    onDateSelected: (persianDateSlash,
                                        persianDateHyphen, englishDateIso8601) {
                                      RequestDetailScreen.startDateNotifire
                                          .value = englishDateIso8601;
                                    },
                                    padding: EdgeInsets.only(bottom: 24),
                                    title: 'تاریخ شروع',
                                  ),
                                  PersianDatePicker(
                                    initialDate: DateTime.now(),
                                    onDateSelected: (persianDateSlash,
                                        persianDateHyphen, englishDateIso8601) {
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
                        ExplanationWidget(),
                      ],
                    ),
                  );
                } else if (state is RequestTypesLoading) {
                  return SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    child: Center(
                      child: CupertinoActivityIndicator(),
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

class PersianDatePicker extends StatefulWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final DateTime initialDate;
  final Function(
    String? persianDateSlash,
    String? persianDateHyphen,
    String? englishDateIso8601,
  )? onDateSelected;

  const PersianDatePicker({
    super.key,
    required this.initialDate,
    this.onDateSelected,
    required this.title,
    required this.padding,
  });

  @override
  State<PersianDatePicker> createState() => _PersianDatePickerState();
}

class _PersianDatePickerState extends State<PersianDatePicker> {
  late ValueNotifier<bool> isPickerOpenNotifier;
  late ValueNotifier<String?> persianDateSlashNotifier;

  @override
  void initState() {
    super.initState();
    isPickerOpenNotifier = ValueNotifier<bool>(false);
    persianDateSlashNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    isPickerOpenNotifier.dispose();
    persianDateSlashNotifier.dispose();
    super.dispose();
  }

  void _openCalendar() {
    PersianCalendar.openCalendar(
      context,
      initialDate: widget.initialDate,
      onDateSelected:
          (persianDateSlash, persianDateHyphen, englishDateIso8601) {
        persianDateSlashNotifier.value = persianDateSlash;
        widget.onDateSelected
            ?.call(persianDateSlash, persianDateHyphen, englishDateIso8601);
        _closeCalendar(); // غیرفعال کردن border بعد از انتخاب تاریخ
      },
      onCalendarStateChange: (isOpen) {
        // تغییرات وضعیت تقویم
        isPickerOpenNotifier.value = isOpen;
      },
    );
  }

  void _closeCalendar() {
    isPickerOpenNotifier.value = false;
    PersianCalendar.closeDropdown();
  }

  Future<bool> _onWillPop() async {
    if (isPickerOpenNotifier.value) {
      _closeCalendar(); // بسته شدن تقویم هنگام فشردن دکمه بک
      return false; // جلوگیری از برگشت به صفحه قبلی
    }
    return true; // اجازه برگشت به صفحه قبلی
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          if (isPickerOpenNotifier.value) {
            _closeCalendar(); // بسته شدن تقویم وقتی بیرون از آن کلیک می‌شود
          }
        },
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalMedium(widget.title),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (isPickerOpenNotifier.value) {
                    _closeCalendar();
                  } else {
                    _openCalendar();
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isPickerOpenNotifier,
                  builder: (context, isOpen, child) {
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOpen
                              ? const Color(0xff861C8C)
                              : const Color(0xffE0E0F9),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ValueListenableBuilder(
                        valueListenable: persianDateSlashNotifier,
                        builder: (context, persianDateSlash, child) {
                          return Row(
                            children: [
                              Assets.icons.calendar.svg(
                                colorFilter: const ColorFilter.mode(
                                    Color(0xffCAC4CF), BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8),
                              persianDateSlash == null
                                  ? NormalRegular(
                                      "--/--/--",
                                      textColorInLight: const Color(0xffCAC4CF),
                                    )
                                  : NormalRegular(persianDateSlash),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
