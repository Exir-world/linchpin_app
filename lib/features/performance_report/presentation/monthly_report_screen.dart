import 'package:calendar_pro_farhad/core/text_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/date_time_extensions.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';
import 'package:linchpin/features/performance_report/presentation/detail_monthly_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class MonthlyReportScreen extends StatefulWidget {
  final String title;
  final String startDate;
  final String endDate;
  const MonthlyReportScreen(
      {super.key,
      required this.title,
      required this.startDate,
      required this.endDate});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    BlocProvider.of<LastQuarterReportBloc>(context).add(ReportEvent(
      startDate: widget.startDate,
      endDate: widget.endDate,
    ));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: BlocBuilder<LastQuarterReportBloc, LastQuarterReportState>(
        buildWhen: (previous, current) {
          if (current is ReportCompletedState ||
              current is ReportLoadingState ||
              current is ReportErrorState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is ReportCompletedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        BigDemiBold(widget.title),
                        // Spacer(),
                        // Assets.icons.documentPdf.svg(),
                        // SizedBox(width: 8),
                        // NormalMedium('دانلود PDF'),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BoxTitle(
                                title:
                                    '${LocaleKeys.totalPresence.tr()}: ${state.reportEntity.attendanceMinutes} ${LocaleKeys.hour.tr()}',
                                color: Color(0xffE6FCF4),
                                titleColor: Color(0xff02B776),
                              ),
                              SizedBox(width: 8),
                              BoxTitle(
                                title:
                                    '${LocaleKeys.useful.tr()}: ${state.reportEntity.workMinutes} ${LocaleKeys.hour.tr()}',
                                color: Color(0xffF5EEFC),
                                titleColor: Color(0xff9B51E0),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              BoxTitle(
                                title:
                                    '${LocaleKeys.overtime.tr()}: ${state.reportEntity.overDuration} ${LocaleKeys.hour.tr()}',
                                color: Color(0xffE5F5FF),
                                titleColor: Color(0xff4897F1),
                              ),
                              SizedBox(width: 8),
                              BoxTitle(
                                title:
                                    '${LocaleKeys.deficit.tr()}: ${state.reportEntity.lessDuration} ${LocaleKeys.hour.tr()}',
                                color: Color(0xffFFEFF1),
                                titleColor: Color(0xffFD5B71),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              BoxTitle(
                                title:
                                    '${LocaleKeys.unpaidLeave.tr()}:${state.reportEntity.leaveWithoutPayrollDuration}${LocaleKeys.hour.tr()}',
                                color: Color(0xffFEF5ED),
                                titleColor: Color(0xffF08B32),
                              ),
                              SizedBox(width: 8),
                              BoxTitle(
                                title:
                                    '${LocaleKeys.paidLeave.tr()}: ${state.reportEntity.leaveWithPayrollDuration} ${LocaleKeys.hour.tr()}',
                                color: Color(0xffFEF5ED),
                                titleColor: Color(0xffF08B32),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      itemCount: state.reportEntity.attendances?.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = state.reportEntity.attendances![index];
                        final DateTime date = DateTime.parse(data.date!);
                        final DateTime firstCheck =
                            DateTime.parse(data.firstCheckIn!.toString());
                        DateTime? lastCheck;
                        if (data.lastCheckOut != null) {
                          lastCheck =
                              DateTime.parse(data.lastCheckOut.toString());
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailMonthlyScreen(
                                    title: 'جزئیات',
                                    date: data.date!,
                                  ),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    NormalRegular(date.toJalaliFormatted()),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffF5EEFC),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: VerySmallRegular(
                                        'کار مفید: ${data.workTime} ${LocaleKeys.hour.tr()}',
                                        textColorInLight: Color(0xff9B51E0),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Assets.icons.checkIn.svg(),
                                    SizedBox(width: 4),
                                    SmallRegular(
                                      '${LocaleKeys.firstEntry.tr()}: ${firstCheck.toTimeFormatted()}',
                                      textColorInLight: Color(0xff861C8C),
                                    ),
                                    SizedBox(width: 24),
                                    Assets.icons.checkOut.svg(height: 18),
                                    SizedBox(width: 4),
                                    lastCheck == null
                                        ? SmallRegular(
                                            '${LocaleKeys.lastExit.tr()}: -')
                                        : SmallRegular(
                                            '${LocaleKeys.lastExit.tr()}: ${lastCheck.toTimeFormatted()}',
                                            textColorInLight: Color(0xff861C8C),
                                          ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xffDADADA),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ReportErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<LastQuarterReportBloc>(context).add(ReportEvent(
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                ));
              },
            );
          } else if (state is ReportLoadingState) {
            return LoadingWidget();
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      ),
    );
  }
}

class BoxTitle extends StatelessWidget {
  final String title;
  final Color color;
  final Color titleColor;
  const BoxTitle({
    super.key,
    required this.title,
    required this.color,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: SmallRegular(
          title,
          textColorInLight: titleColor,
        ),
      ),
    );
  }
}
