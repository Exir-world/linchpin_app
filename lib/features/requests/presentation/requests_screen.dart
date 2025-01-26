import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/features/requests/presentation/bloc/requests_bloc.dart';
import 'package:linchpin_app/features/requests/presentation/request_detail_screen.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';
import 'package:shamsi_date/shamsi_date.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    BlocProvider.of<RequestsBloc>(context).add(RequestUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: BlocConsumer<RequestsBloc, RequestsState>(
            listener: (context, state) {
              if (state is RequestCancelCompleted) {
                BlocProvider.of<RequestsBloc>(context).add(RequestUser());
              }
            },
            buildWhen: (previous, current) {
              return current is RequestsCompleted ||
                  current is RequestsLoading ||
                  current is RequestsError;
            },
            builder: (context, state) {
              if (state is RequestsCompleted) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: padding_Horizantalx),
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Row(
                        children: [
                          BigDemiBold('درخواست ها'),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestDetailScreen(),
                                  ));
                            },
                            child: Row(
                              children: [
                                Assets.icons.plus.svg(),
                                SizedBox(width: 8),
                                NormalMedium(
                                  'ثبت درخواست جدید',
                                  textColorInLight: Color(0xff861C8C),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      state.requestUserEntity.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NormalRegular(
                                    'درخواستی وجود ندارد',
                                    textColorInLight: Color(0xffCAC4CF),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.requestUserEntity.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = state.requestUserEntity[index];
                                String createdAt =
                                    '${Jalali.fromDateTime(data.createdAt!).formatter.y}/${Jalali.fromDateTime(data.createdAt!).formatter.m}/${Jalali.fromDateTime(data.createdAt!).formatter.d}';
                                String startTimeH =
                                    '${data.startTime!.hour.toString()}:${data.startTime!.minute.toString()}';
                                String endTimeH =
                                    '${data.endTime!.hour.toString()}:${data.endTime!.minute.toString()}';

                                String startDay =
                                    '${Jalali.fromDateTime(data.startTime!).formatter.y}/${Jalali.fromDateTime(data.startTime!).formatter.m}/${Jalali.fromDateTime(data.startTime!).formatter.d}';

                                String endDay =
                                    '${Jalali.fromDateTime(data.endTime!).formatter.y}/${Jalali.fromDateTime(data.endTime!).formatter.m}/${Jalali.fromDateTime(data.endTime!).formatter.d}';
                                return Container(
                                  height: 92,
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                NormalRegular(data.type ==
                                                        'SICK_LEAVE'
                                                    ? 'مرخصی استعلاجی - '
                                                    : data.type ==
                                                            'HOURLY_LEAVE'
                                                        ? 'مرخصی ساعتی - '
                                                        : data.type ==
                                                                'DAILY_LEAVE'
                                                            ? 'مرخصی روزانه - '
                                                            : data.type ==
                                                                    'MANUAL_CHECK_OUT'
                                                                ? 'تردد دستی (خروج) - '
                                                                : data.type ==
                                                                        'MANUAL_CHECK_IN'
                                                                    ? 'تردد دستی (ورود) - '
                                                                    : ''),
                                                NormalRegular(createdAt),
                                                Spacer(),
                                                SmallRegular(
                                                  data.status == 'PENDING'
                                                      ? 'در حال انتظار'
                                                      : data.status ==
                                                              'APPROVED'
                                                          ? 'تایید شده'
                                                          : data.status ==
                                                                  'REJECTED'
                                                              ? 'رد شده'
                                                              : data.status ==
                                                                      'CANCELLED'
                                                                  ? 'لغو شده'
                                                                  : '',
                                                  textColorInLight:
                                                      Color(0xff828282),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                data.type == 'SICK_LEAVE'
                                                    ? Assets.icons.timerOffSleep
                                                        .svg()
                                                    : data.type ==
                                                            'HOURLY_LEAVE'
                                                        ? Assets.icons.clockDash
                                                            .svg()
                                                        : data.type ==
                                                                'DAILY_LEAVE'
                                                            ? Assets
                                                                .icons.checkOut
                                                                .svg()
                                                            : data.type ==
                                                                    'MANUAL_CHECK_OUT'
                                                                ? Assets.icons
                                                                    .clockClose
                                                                    .svg()
                                                                : data.type ==
                                                                        'MANUAL_CHECK_IN'
                                                                    ? Assets
                                                                        .icons
                                                                        .clockAdd
                                                                        .svg()
                                                                    : Assets
                                                                        .icons
                                                                        .clockAdd
                                                                        .svg(),
                                                SizedBox(width: 8),
                                                SmallRegular(
                                                  data.type == 'SICK_LEAVE'
                                                      ? 'تاریخ $startDay الی $endDay'
                                                      : data.type ==
                                                              'HOURLY_LEAVE'
                                                          ? 'ساعت $startTimeH الی $endTimeH'
                                                          : data.type ==
                                                                  'DAILY_LEAVE'
                                                              ? 'تاریخ $startDay الی $endDay'
                                                              : data.type ==
                                                                      'MANUAL_CHECK_OUT'
                                                                  ? 'خروج برای ساعت $endTimeH'
                                                                  : data.type ==
                                                                          'MANUAL_CHECK_IN'
                                                                      ? 'ورود برای ساعت $startTimeH'
                                                                      : '',
                                                  textColorInLight:
                                                      Color(0xff861C8C),
                                                ),
                                                Spacer(),
                                                data.status == 'CANCELLED' ||
                                                        data.status ==
                                                            'REJECTED'
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      RequestsBloc>(
                                                                  context)
                                                              .add(RequestCancelEvent(data
                                                                  .id
                                                                  .toString()));
                                                        },
                                                        child: Assets.icons.tag
                                                            .svg()),
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
                );
              } else if (state is RequestsLoading) {
                return SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else if (state is RequestsError) {
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
    );
  }
}
