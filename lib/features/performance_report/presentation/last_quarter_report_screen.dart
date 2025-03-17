import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/dimens.dart';
import 'package:linchpin/core/common/text_widgets.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';
import 'package:linchpin/features/performance_report/presentation/monthly_report_screen.dart';
import 'package:linchpin/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class LastQuarterReportScreen extends StatefulWidget {
  const LastQuarterReportScreen({super.key});

  @override
  State<LastQuarterReportScreen> createState() =>
      _LastQuarterReportScreenState();
}

class _LastQuarterReportScreenState extends State<LastQuarterReportScreen> {
  @override
  void initState() {
    BlocProvider.of<LastQuarterReportBloc>(context).add(MonthsEvent());
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<LastQuarterReportBloc>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LastQuarterReportBloc, LastQuarterReportState>(
          buildWhen: (previous, current) {
            if (current is MonthsCompletedState ||
                current is MonthsLoadingState ||
                current is MonthsErrorState) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is MonthsCompletedState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: VERTICAL_SPACING_4x),
                      BigDemiBold(LocaleKeys.performanceReport.tr()),
                      SizedBox(height: VERTICAL_SPACING_6x),
                      state.monthsEntity.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: context.screenHeight / 3.2,
                                ),
                                Center(
                                  child: NormalRegular(
                                    LocaleKeys.noRecorded.tr(),
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
                                    Jalali.fromDateTime(data.startOfMonth!);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MonthlyReportScreen(
                                            title:
                                                '${LocaleKeys.reportPerformance.tr()} ${dateTitle.formatter.mN} ${dateTitle.formatter.y}',
                                            startDate:
                                                data.startOfMonth.toString(),
                                            endDate: data.endOfMonth.toString(),
                                          ),
                                        ));
                                  },
                                  child: Container(
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
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                        NormalMedium(
                                            '${LocaleKeys.workingHours.tr()} ${dateTitle.formatter.mN} ${dateTitle.formatter.y}'),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Color(0xffDADADA),
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
            } else if (state is MonthsLoadingState) {
              return LoadingWidget();
            } else if (state is MonthsErrorState) {
              return ErrorUiWidget(
                title: state.errorText,
                onTap: () {
                  BlocProvider.of<LastQuarterReportBloc>(context)
                      .add(MonthsEvent());
                },
              );
            } else {
              return Center(child: NormalMedium("data"));
            }
          },
        ),
      ),
    );
  }
}
