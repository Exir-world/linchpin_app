import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class LastQuarterReportScreen extends StatefulWidget {
  const LastQuarterReportScreen({super.key});

  @override
  State<LastQuarterReportScreen> createState() =>
      _LastQuarterReportScreenState();
}

class _LastQuarterReportScreenState extends State<LastQuarterReportScreen> {
  late LastQuarterReportBloc _bloc;
  @override
  void initState() {
    _bloc = getIt<LastQuarterReportBloc>();
    _bloc.add(MonthsEvent());
    super.initState();
  }

  String formatWorkMinutes(int workMinutes) {
    if (workMinutes < 60) {
      // اگر زیر یک ساعت باشد
      return '$workMinutes دقیقه';
    } else {
      // اگر بالای یک ساعت باشد
      int hours = workMinutes ~/ 60; // تقسیم صحیح (ساعت)
      return '$hours ساعت';
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LastQuarterReportBloc, LastQuarterReportState>(
            builder: (context, state) {
              if (state is MonthsCompletedState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: padding_Horizantalx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: VERTICAL_SPACING_6x),
                        LargeDemiBold("گزارش عملکرد"),
                        SizedBox(height: VERTICAL_SPACING_6x),
                        state.monthsEntity.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: context.screenHeight / 3.2,
                                  ),
                                  Center(
                                    child: NormalRegular(
                                      'عملکردی ثبت نشده',
                                      textColorInLight: Color(0xffCAC4CF),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: state.monthsEntity.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data = state.monthsEntity[index];
                                  final dateTitle =
                                      Jalali.fromDateTime(data.date!);
                                  final String workTime =
                                      formatWorkMinutes(data.workMinutes!);

                                  // کسری
                                  final String lessTime =
                                      formatWorkMinutes(data.lessDuration!);

                                  // اضافه کار
                                  final String overTime =
                                      formatWorkMinutes(data.overDuration!);

                                  // مرخصی
                                  final String leaveTime =
                                      formatWorkMinutes(data.leaveDuration!);

                                  // کل حضور
                                  final String sumTime = formatWorkMinutes(
                                      data.workMinutes! + data.overDuration!);

                                  return Container(
                                    height: 100,
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 3),
                                          blurRadius: 30,
                                          color: Color(0xff828282)
                                              .withValues(alpha: 0.04),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (data.month! >= 1 &&
                                            data.month! <= 3)
                                          Assets.icons.spring.svg(),
                                        if (data.month! >= 4 &&
                                            data.month! <= 6)
                                          Assets.icons.summer.svg(),
                                        if (data.month! >= 7 &&
                                            data.month! <= 9)
                                          Assets.icons.autumn.svg(),
                                        if (data.month! >= 10 &&
                                            data.month! <= 12)
                                          Assets.icons.winter.svg(),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  NormalMedium(
                                                      'ساعات کاری ${dateTitle.formatter.mN} ${dateTitle.formatter.y}'),
                                                  SmallMedium(sumTime),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  _BoxTime(
                                                    time: 'مفید: $workTime',
                                                    colorBox: Color(0xffF5EEFC),
                                                    colorTitle:
                                                        Color(0xff9B51E0),
                                                    isWidth: true,
                                                  ),
                                                  data.lessDuration! == 0 &&
                                                          data.overDuration! ==
                                                              0 &&
                                                          data.leaveDuration! ==
                                                              0
                                                      ? Container()
                                                      : SizedBox(width: 8),
                                                  data.lessDuration! == 0 &&
                                                          data.overDuration! ==
                                                              0 &&
                                                          data.leaveDuration! ==
                                                              0
                                                      ? Container()
                                                      : data.lessDuration! > 0
                                                          ? _BoxTime(
                                                              time:
                                                                  'کسری: $lessTime',
                                                              colorBox: Color(
                                                                  0xffFFEFF1),
                                                              colorTitle: Color(
                                                                  0xffFD5B71),
                                                              isWidth: false,
                                                            )
                                                          : data.overDuration! >
                                                                  0
                                                              ? _BoxTime(
                                                                  time:
                                                                      'اضافه کار: $overTime',
                                                                  colorBox: Color(
                                                                      0xffE6FCF4),
                                                                  colorTitle: Color(
                                                                      0xff07E092),
                                                                  isWidth:
                                                                      false,
                                                                )
                                                              : data.leaveDuration! >
                                                                      0
                                                                  ? _BoxTime(
                                                                      time:
                                                                          'مرخصی: $leaveTime',
                                                                      colorBox:
                                                                          Color(
                                                                              0xffFFA656),
                                                                      colorTitle:
                                                                          Color(
                                                                              0xffFEF5ED),
                                                                      isWidth:
                                                                          false,
                                                                    )
                                                                  : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                );
              } else if (state is MonthsLoadingState) {
                return LoadingWidget();
              } else if (state is MonthsErrorState) {
                return ErrorUiWidget(
                  title: state.errorText,
                  onTap: () {
                    _bloc.add(MonthsEvent());
                  },
                );
              } else {
                return Center(child: Text("data"));
              }
            },
          ),
        ),
      ),
    );
  }
}

class _BoxTime extends StatelessWidget {
  final String time;
  final Color colorBox;
  final Color colorTitle;
  final bool isWidth;
  const _BoxTime({
    required this.time,
    required this.colorBox,
    required this.colorTitle,
    required this.isWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colorBox,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: SmallRegular(
        time,
        textColorInLight: colorTitle,
      ),
    );
  }
}
