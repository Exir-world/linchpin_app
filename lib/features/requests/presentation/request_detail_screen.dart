import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/requests/presentation/bloc/requests_bloc.dart';
import 'package:linchpin/features/requests/presentation/widgets/box_request_type.dart';
import 'package:linchpin/features/requests/presentation/widgets/clock_picker_example.dart';
import 'package:linchpin/features/requests/presentation/widgets/explanation_widget.dart';
import 'package:linchpin/features/requests/presentation/widgets/persian_date_picker.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
  static late ValueNotifier<String?> startDateNotifire;
  static late ValueNotifier<String?> endDateNotifire;
  static late ValueNotifier<bool> isButtonEnabled;

  // نوتیفایرهای جدید برای ساعت و دقیقه شروع و پایان
  static late ValueNotifier<int?> startHourNotifire;
  static late ValueNotifier<int?> startMinuteNotifire;
  static late ValueNotifier<int?> endHourNotifire;
  static late ValueNotifier<int?> endMinuteNotifire;

  static late ValueNotifier<bool> isStartDateFilled;
  static late ValueNotifier<bool> isEndDateFilled;
  static late ValueNotifier<bool> isStartHourFilled;
  static late ValueNotifier<bool> isStartMinuteFilled;
  static late ValueNotifier<bool> isEndHourFilled;
  static late ValueNotifier<bool> isEndMinuteFilled;
}

class _RequestDetailScreenState extends State<RequestDetailScreen>
    with WidgetsBindingObserver {
  late RequestsBloc _bloc;
  bool isLoading = false;
  void checkFormCompletion() {
    final type = BoxRequestType.selectedItemNotifire.value;

    bool isComplete = false;

    // Reset isButtonEnabled to false when the request type changes
    if (type == null) {
      RequestDetailScreen.isButtonEnabled.value = false;
      return;
    } else {
      switch (type) {
        case 'MANUAL_CHECK_IN':
        case 'MANUAL_CHECK_OUT':
          // Needs start date, start hour, and start minute
          isComplete = RequestDetailScreen.isStartDateFilled.value &&
              RequestDetailScreen.isStartHourFilled.value &&
              RequestDetailScreen.isStartMinuteFilled.value;
          break;
        case 'HOURLY_LEAVE':
          // Needs start date, start hour, start minute, end hour, and end minute
          isComplete = RequestDetailScreen.isStartDateFilled.value &&
              RequestDetailScreen.isStartHourFilled.value &&
              RequestDetailScreen.isStartMinuteFilled.value &&
              RequestDetailScreen.isEndHourFilled.value &&
              RequestDetailScreen.isEndMinuteFilled.value;
          break;
        case 'SICK_LEAVE':
        case 'DAILY_LEAVE':
          // Needs start date and end date
          isComplete = RequestDetailScreen.isStartDateFilled.value &&
              RequestDetailScreen.isEndDateFilled.value;
          break;
      }

      // Update isButtonEnabled based on form completion
      RequestDetailScreen.isButtonEnabled.value = isComplete;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = getIt<RequestsBloc>();
    RequestDetailScreen.startDateNotifire = ValueNotifier(null);
    RequestDetailScreen.endDateNotifire = ValueNotifier(null);
    RequestDetailScreen.startHourNotifire = ValueNotifier(null);
    RequestDetailScreen.startMinuteNotifire = ValueNotifier(null);
    RequestDetailScreen.endHourNotifire = ValueNotifier(null);
    RequestDetailScreen.endMinuteNotifire = ValueNotifier(null);
    RequestDetailScreen.isButtonEnabled = ValueNotifier(false);
    RequestDetailScreen.isStartDateFilled = ValueNotifier(false);
    RequestDetailScreen.isEndDateFilled = ValueNotifier(false);
    RequestDetailScreen.isStartHourFilled = ValueNotifier(false);
    RequestDetailScreen.isStartMinuteFilled = ValueNotifier(false);
    RequestDetailScreen.isEndHourFilled = ValueNotifier(false);
    RequestDetailScreen.isEndMinuteFilled = ValueNotifier(false);
    BoxRequestType.selectedItemNotifire.value = null;
    RequestDetailScreen.isStartDateFilled.addListener(checkFormCompletion);
    RequestDetailScreen.isEndDateFilled.addListener(checkFormCompletion);
    RequestDetailScreen.isStartHourFilled.addListener(checkFormCompletion);
    RequestDetailScreen.isEndHourFilled.addListener(checkFormCompletion);
    RequestDetailScreen.isStartMinuteFilled.addListener(checkFormCompletion);
    RequestDetailScreen.isEndMinuteFilled.addListener(checkFormCompletion);
    _bloc.add(RequestTypesEvent());
  }

  void updateNotifier(ValueNotifier<bool> notifier, bool value) {
    if (notifier.value != value) {
      notifier.value = value;
      checkFormCompletion();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    RequestDetailScreen.isStartDateFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.isEndDateFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.isStartHourFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.isEndHourFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.isStartMinuteFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.isEndMinuteFilled.removeListener(checkFormCompletion);
    RequestDetailScreen.startDateNotifire.dispose();
    RequestDetailScreen.endDateNotifire.dispose();
    RequestDetailScreen.startHourNotifire.dispose();
    RequestDetailScreen.startMinuteNotifire.dispose();
    RequestDetailScreen.endHourNotifire.dispose();
    RequestDetailScreen.endMinuteNotifire.dispose();
    RequestDetailScreen.isButtonEnabled.dispose();
    RequestDetailScreen.isStartDateFilled.dispose();
    RequestDetailScreen.isEndDateFilled.dispose();
    RequestDetailScreen.isStartHourFilled.dispose();
    RequestDetailScreen.isStartMinuteFilled.dispose();
    RequestDetailScreen.isEndHourFilled.dispose();
    RequestDetailScreen.isEndMinuteFilled.dispose();

    _bloc.close();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: appBarRoot(context, true),
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: isLoading
            ? null
            : ValueListenableBuilder(
                valueListenable: BoxRequestType.selectedItemNotifire,
                builder: (context, value, child) {
                  if (value == null) {
                    return Container();
                  } else {
                    return ValueListenableBuilder<bool>(
                      valueListenable: RequestDetailScreen.isButtonEnabled,
                      builder: (context, isEnabled, child) {
                        return GestureDetector(
                          onTap: isEnabled
                              ? () {
                                  final type =
                                      BoxRequestType.selectedItemNotifire.value;
                                  final startDate = RequestDetailScreen
                                      .startDateNotifire.value;
                                  final endDate =
                                      RequestDetailScreen.endDateNotifire.value;
                                  final description = ExplanationWidget
                                      .explanationNotifire.value;

                                  String? formatDateTime(String date,
                                      String? hour, String? minute) {
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
                                    return dateTime
                                        .toString()
                                        .replaceAll(' ', 'T');
                                  }

                                  void sendRequest(
                                      {required String startTime,
                                      String? endTime}) {
                                    _bloc.add(
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
                                        if (startDate != null &&
                                            RequestDetailScreen
                                                    .startHourNotifire.value !=
                                                null &&
                                            RequestDetailScreen
                                                    .startMinuteNotifire
                                                    .value !=
                                                null) {
                                          final startTime = formatDateTime(
                                            startDate,
                                            RequestDetailScreen
                                                .startHourNotifire.value
                                                .toString(),
                                            RequestDetailScreen
                                                .startMinuteNotifire.value
                                                .toString(),
                                          );
                                          if (startTime != null) {
                                            sendRequest(startTime: startTime);
                                          }
                                        }
                                        break;
                                      }

                                    case 'HOURLY_LEAVE':
                                      {
                                        if (startDate != null &&
                                            RequestDetailScreen
                                                    .startHourNotifire.value !=
                                                null &&
                                            RequestDetailScreen
                                                    .startMinuteNotifire
                                                    .value !=
                                                null &&
                                            RequestDetailScreen
                                                    .endHourNotifire.value !=
                                                null &&
                                            RequestDetailScreen
                                                    .endMinuteNotifire.value !=
                                                null) {
                                          final startTime = formatDateTime(
                                            startDate,
                                            RequestDetailScreen
                                                .startHourNotifire.value
                                                .toString(),
                                            RequestDetailScreen
                                                .startMinuteNotifire.value
                                                .toString(),
                                          );
                                          final endTime = formatDateTime(
                                            startDate,
                                            RequestDetailScreen
                                                .endHourNotifire.value
                                                .toString(),
                                            RequestDetailScreen
                                                .endMinuteNotifire.value
                                                .toString(),
                                          );
                                          if (startTime != null &&
                                              endTime != null) {
                                            sendRequest(
                                                startTime: startTime,
                                                endTime: endTime);
                                          }
                                        }
                                        break;
                                      }

                                    case 'SICK_LEAVE':
                                    case 'DAILY_LEAVE':
                                      {
                                        if (startDate != null &&
                                            endDate != null) {
                                          sendRequest(
                                              startTime: startDate,
                                              endTime: endDate);
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
                              color: isEnabled
                                  ? Color(0xff861C8C)
                                  : Color(0xffCAC4CF),
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
                    );
                  }
                },
              ),
        body: GestureDetector(
          onTap: () {
            // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
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
                    // جهت مدیریت همزمان محتوا و لودینگ
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
                              // باکس نوع درخواست
                              BoxRequestType(state: state.requestTypesEntity),
                              SizedBox(height: 24),
                              // زمانی که نوع درخواست تردد ورود یا تردد خروج یا مرخصی ساعتی باشه
                              // ساعت
                              ValueListenableBuilder(
                                valueListenable:
                                    BoxRequestType.selectedItemNotifire,
                                builder: (context, selectedItem, child) {
                                  if (selectedItem == 'MANUAL_CHECK_IN' ||
                                      selectedItem == 'MANUAL_CHECK_OUT' ||
                                      selectedItem == 'HOURLY_LEAVE') {
                                    return ClockPickerExample(
                                      title: selectedItem == 'MANUAL_CHECK_OUT'
                                          ? 'ساعت پایان'
                                          : 'ساعت شروع',
                                      onChange: (TimeOfDay time) {
                                        // ذخیره ساعت و دقیقه در نوتیفایرهای جدید
                                        RequestDetailScreen.startHourNotifire
                                            .value = time.hour;
                                        updateNotifier(
                                            RequestDetailScreen
                                                .isStartHourFilled,
                                            true);
                                        RequestDetailScreen.startMinuteNotifire
                                            .value = time.minute;
                                        updateNotifier(
                                            RequestDetailScreen
                                                .isStartMinuteFilled,
                                            true);
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              // زمانی نوع درخواست مرخصی ساعتی باشه
                              // ساعت خروج
                              ValueListenableBuilder(
                                valueListenable:
                                    BoxRequestType.selectedItemNotifire,
                                builder: (context, selectedItem, child) {
                                  if (selectedItem == 'HOURLY_LEAVE') {
                                    return Column(
                                      children: [
                                        SizedBox(height: 24),
                                        ClockPickerExample(
                                          title: 'ساعت خروج',
                                          onChange: (TimeOfDay time) {
                                            // ذخیره ساعت و دقیقه پایان در نوتیفایرهای جدید
                                            RequestDetailScreen.endHourNotifire
                                                .value = time.hour;
                                            updateNotifier(
                                                RequestDetailScreen
                                                    .isEndHourFilled,
                                                true);
                                            RequestDetailScreen
                                                .endMinuteNotifire
                                                .value = time.minute;
                                            updateNotifier(
                                                RequestDetailScreen
                                                    .isEndMinuteFilled,
                                                true);
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              // زمانی که نوع درخواست تردد ورود یا تردد خروج یا مرخصی ساعتی باشه
                              // نمایش تاریخ
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
                                          persianDateHyphen,
                                          englishDateIso8601) {
                                        if (englishDateIso8601 != null) {
                                          RequestDetailScreen.startDateNotifire
                                              .value = englishDateIso8601;
                                          updateNotifier(
                                              RequestDetailScreen
                                                  .isStartDateFilled,
                                              true);
                                        } else {
                                          updateNotifier(
                                              RequestDetailScreen
                                                  .isStartDateFilled,
                                              false);
                                        }
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
                              // زمانی که نوع درخواست، مرخصی روزانه باشد
                              ValueListenableBuilder(
                                valueListenable:
                                    BoxRequestType.selectedItemNotifire,
                                builder: (context, selectedItem, child) {
                                  if (selectedItem == 'DAILY_LEAVE') {
                                    return Column(
                                      children: [
                                        PersianDatePicker(
                                          initialDate: DateTime.now(),
                                          onDateSelected: (
                                            persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601,
                                          ) {
                                            if (englishDateIso8601 != null) {
                                              RequestDetailScreen
                                                  .startDateNotifire
                                                  .value = englishDateIso8601;
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isStartDateFilled,
                                                  true);
                                            } else {
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isStartDateFilled,
                                                  false);
                                            }
                                          },
                                          padding: EdgeInsets.only(bottom: 24),
                                          title: 'تاریخ شروع',
                                        ),
                                        PersianDatePicker(
                                          initialDate: DateTime.now(),
                                          onDateSelected: (
                                            persianDateSlash,
                                            persianDateHyphen,
                                            englishDateIso8601,
                                          ) {
                                            if (englishDateIso8601 != null) {
                                              RequestDetailScreen
                                                  .endDateNotifire
                                                  .value = englishDateIso8601;
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isEndDateFilled,
                                                  true);
                                            } else {
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isEndDateFilled,
                                                  false);
                                            }
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
                              // زمانی که نوع درخواست، مرخصی استعلاجی باشد
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
                                            if (englishDateIso8601 != null) {
                                              RequestDetailScreen
                                                  .startDateNotifire
                                                  .value = englishDateIso8601;
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isStartDateFilled,
                                                  true);
                                            } else {
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isStartDateFilled,
                                                  false);
                                            }
                                          },
                                          padding: EdgeInsets.only(bottom: 24),
                                          title: 'تاریخ شروع',
                                        ),
                                        PersianDatePicker(
                                          initialDate: DateTime.now(),
                                          onDateSelected: (persianDateSlash,
                                              persianDateHyphen,
                                              englishDateIso8601) {
                                            if (englishDateIso8601 != null) {
                                              RequestDetailScreen
                                                  .endDateNotifire
                                                  .value = englishDateIso8601;
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isEndDateFilled,
                                                  true);
                                            } else {
                                              updateNotifier(
                                                  RequestDetailScreen
                                                      .isEndDateFilled,
                                                  false);
                                            }
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
                              // نمایش تکست فیلد توضیحات
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
                        if (isLoading) LoadingWidget(),
                      ],
                    );
                  } else if (state is RequestTypesLoading) {
                    return LoadingWidget();
                  } else if (state is RequestTypesError) {
                    return ErrorUiWidget(
                      title: state.textError,
                      onTap: () {
                        _bloc.add(RequestTypesEvent());
                      },
                    );
                  } else {
                    return ErrorUiWidget(
                      title: 'Technical error',
                      onTap: () {},
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
