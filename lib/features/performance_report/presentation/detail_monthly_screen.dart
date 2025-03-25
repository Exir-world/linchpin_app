import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/date_time_extensions.dart';
import 'package:linchpin/core/extension/time_conversion.dart';
import 'package:linchpin/core/translate/locale_keys.dart';
import 'package:linchpin/features/performance_report/presentation/bloc/last_quarter_report_bloc.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class DetailMonthlyScreen extends StatefulWidget {
  final String title;
  final String date;
  const DetailMonthlyScreen({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  State<DetailMonthlyScreen> createState() => _DetailMonthlyScreenState();
}

class _DetailMonthlyScreenState extends State<DetailMonthlyScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    BlocProvider.of<LastQuarterReportBloc>(context)
        .add(DailyReportEvent(widget.date));
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
        builder: (context, state) {
          if (state is DailyReportCompletedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    BigDemiBold(widget.title),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount:
                                state.dailyReportEntity.attendances?.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data =
                                  state.dailyReportEntity.attendances![index];
                              final dateCheckIn =
                                  DateTime.parse(data.checkIn.toString())
                                      .toLocal();
                              DateTime? dateCheckOut;
                              if (data.checkOut != null) {
                                dateCheckOut =
                                    DateTime.parse(data.checkOut.toString())
                                        .toLocal();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Assets.icons.checkIn.svg(),
                                    SizedBox(width: 4),
                                    NormalRegular(
                                      '${LocaleKeys.arrival.tr()}: ${dateCheckIn.toTimeFormatted()}',
                                      textColorInLight: Color(0xff861C8C),
                                    ),
                                    Spacer(),
                                    Assets.icons.checkOut.svg(height: 18),
                                    SizedBox(width: 4),
                                    dateCheckOut == null
                                        ? NormalRegular(
                                            '${LocaleKeys.exit.tr()}: -')
                                        : NormalRegular(
                                            '${LocaleKeys.exit.tr()}: ${dateCheckOut.toTimeFormatted()}',
                                            textColorInLight: Color(0xff861C8C),
                                          ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24),
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Color(0xffE0E0F9).withValues(alpha: .4),
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NormalMedium(
                                  '${LocaleKeys.attendanceHours.tr()}:'),
                              NormalMedium(
                                state.dailyReportEntity.attendanceMinutes!
                                    .toHoursAndMinutes(),
                                textColorInLight: Color(0xff861C8C),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NormalMedium('${LocaleKeys.usefulHours.tr()}:'),
                              NormalMedium(
                                state.dailyReportEntity.workMinutes!
                                    .toHoursAndMinutes(),
                                textColorInLight: Color(0xff861C8C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is DailyReportLoadingState) {
            return LoadingWidget();
          } else if (state is DailyReportErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<LastQuarterReportBloc>(context)
                    .add(DailyReportEvent(widget.date));
              },
            );
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      ),
    );
  }
}
