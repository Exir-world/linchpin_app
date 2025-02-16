import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/core/customui/loading_widget.dart';
import 'package:linchpin_app/core/extension/context_extension.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
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

class _RequestsScreenState extends State<RequestsScreen>
    with WidgetsBindingObserver {
  late RequestsBloc _bloc;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _bloc = getIt<RequestsBloc>();
    _bloc.add(RequestUser());
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PaintingBinding.instance.reassembleApplication();
    }
  }

  String _formatDate(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    return '${jalali.formatter.y}/${jalali.formatter.m}/${jalali.formatter.d}';
  }

  String _formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String getTypeLabel(String type) {
    final typeLabels = {
      'SICK_LEAVE': 'مرخصی استعلاجی - ',
      'HOURLY_LEAVE': 'مرخصی ساعتی - ',
      'DAILY_LEAVE': 'مرخصی روزانه - ',
      'MANUAL_CHECK_OUT': 'تردد دستی (خروج) - ',
      'MANUAL_CHECK_IN': 'تردد دستی (ورود) - ',
    };

    return typeLabels[type] ?? '';
  }

  String getStatusLabel(String status) {
    final statusLabels = {
      'PENDING': 'در حال انتظار',
      'APPROVED': 'تایید شده',
      'REJECTED': 'رد شده',
      'CANCELLED': 'لغو شده',
    };

    return statusLabels[status] ?? '';
  }

  Widget _getIconForType(String type) {
    final iconsMap = {
      'SICK_LEAVE': Assets.icons.timerOffSleep.svg(),
      'HOURLY_LEAVE': Assets.icons.clockDash.svg(),
      'DAILY_LEAVE': Assets.icons.checkOut.svg(),
      'MANUAL_CHECK_OUT': Assets.icons.clockClose.svg(),
      'MANUAL_CHECK_IN': Assets.icons.clockAdd.svg(),
    };

    return iconsMap[type] ?? Assets.icons.clockAdd.svg();
  }

  String _getDetailsForType({
    required String type,
    required String startDay,
    required String endDay,
    required String startTimeH,
    required String endTimeH,
  }) {
    final detailsMap = {
      'SICK_LEAVE': 'تاریخ $startDay الی $endDay',
      'HOURLY_LEAVE': 'ساعت $startTimeH الی $endTimeH',
      'DAILY_LEAVE': 'تاریخ $startDay الی $endDay',
      'MANUAL_CHECK_OUT': 'خروج برای ساعت $endTimeH',
      'MANUAL_CHECK_IN': 'ورود برای ساعت $startTimeH',
    };

    return detailsMap[type] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: appBarRoot(context, true),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: SizedBox(
          height: 56,
          width: 56,
          child: FloatingActionButton(
            shape: CircleBorder(),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                  color: Color(0xff861C8C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(8, 8),
                      blurRadius: 15,
                      color: Color(0xffE549FE).withValues(alpha: 0.15),
                    ),
                  ]),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestDetailScreen()),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    _bloc.add(RequestUser());
                  });
                }
              });
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocConsumer<RequestsBloc, RequestsState>(
              listener: (context, state) {
                if (state is RequestCancelCompleted) {
                  _bloc.add(RequestUser());
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
                            Assets.icons.filter.svg(),
                            SizedBox(width: 8),
                            NormalMedium(
                              'فیلتر کردن',
                              textColorInLight: Color(0xff861C8C),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        state.requestUserEntity.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: context.screenHeight / 3.2,
                                  ),
                                  NormalRegular(
                                    'درخواستی وجود ندارد',
                                    textColorInLight: Color(0xffCAC4CF),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: state.requestUserEntity.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final data = state.requestUserEntity[index];
                                  DateTime startTime =
                                      data.startTime!.toLocal();
                                  DateTime? endTime = data.endTime?.toLocal();
                                  String createdAt = _formatDate(startTime);
                                  String startTimeH = _formatTime(startTime);
                                  String endTimeH = endTime != null
                                      ? _formatTime(endTime)
                                      : _formatTime(startTime);
                                  String startDay = _formatDate(startTime);
                                  String endDay = endTime != null
                                      ? _formatDate(endTime)
                                      : _formatTime(startTime);
                                  return Container(
                                    height: 92,
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
                                                  NormalRegular(
                                                      getTypeLabel(data.type!)),
                                                  NormalRegular(createdAt),
                                                  Spacer(),
                                                  SmallRegular(
                                                    getStatusLabel(
                                                        data.status!),
                                                    textColorInLight:
                                                        Color(0xff828282),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  _getIconForType(data.type!),
                                                  SizedBox(width: 8),
                                                  SmallRegular(
                                                    _getDetailsForType(
                                                      type: data.type!,
                                                      startDay: startDay,
                                                      endDay: endDay,
                                                      startTimeH: startTimeH,
                                                      endTimeH: endTimeH,
                                                    ),
                                                    textColorInLight:
                                                        const Color(0xff861C8C),
                                                  ),
                                                  Spacer(),
                                                  data.status == 'CANCELLED' ||
                                                          data.status ==
                                                              'REJECTED'
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            showDialog<
                                                                TimeOfDay>(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          24,
                                                                      horizontal:
                                                                          24,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        NormalMedium(
                                                                          'از لغو درخواست خود اطمینان دارید؟',
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                24),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _bloc.add(RequestCancelEvent(data.id.toString()));
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 44,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xff861C8C),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: NormalMedium(
                                                                                    'بله',
                                                                                    textColorInLight: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 24),
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 44,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color(0xffCAC4CF),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: NormalMedium('خیر', textColorInLight: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Assets
                                                              .icons.tag
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
                  return LoadingWidget();
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
      ),
    );
  }
}
