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

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
  static ValueNotifier<String?> dateNotifire = ValueNotifier(null);
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    BoxRequestType.selectedItemNotifire.value = null;
    RequestDetailScreen.dateNotifire.value = null;
    ClockBox.hourNotifire.value = null;
    ClockBox.minuteNotifire.value = null;
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
              RequestDetailScreen.dateNotifire.value != null) {
            if (BoxRequestType.selectedItemNotifire.value ==
                    'MANUAL_CHECK_IN' &&
                ClockBox.hourNotifire.value != null &&
                ClockBox.minuteNotifire.value != null) {
              // ساعت و دقیقه از Box
              String hour = ClockBox.hourNotifire.value!;
              String minute = ClockBox.minuteNotifire.value!;

              // تاریخ اولیه
              String date = RequestDetailScreen.dateNotifire.value!;

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

              print(formattedDate);
              // اگر تردد دستی ورود بود
              BlocProvider.of<RequestsBloc>(context).add(
                RequestCreateEvent(
                  type: BoxRequestType.selectedItemNotifire.value!,
                  description: ExplanationWidget.explanationNotifire.value,
                  startTime: formattedDate,
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
                              return Column(
                                children: [
                                  SizedBox(height: 24),
                                  PersianCalendar(
                                    initialDate: DateTime(2025, 1, 14),
                                    onDateSelected: (
                                      persianDateSlash,
                                      persianDateHyphen,
                                      englishDateIso8601,
                                    ) {
                                      RequestDetailScreen.dateNotifire.value =
                                          englishDateIso8601;
                                      debugPrint(persianDateSlash);
                                      debugPrint(persianDateHyphen);
                                      debugPrint(englishDateIso8601);
                                    },
                                  ),
                                  SizedBox(height: 24),
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
