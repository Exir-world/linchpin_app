import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/context_extension.dart';
import 'package:linchpin/core/extension/date_time_extensions.dart';
import 'package:linchpin/features/pay_slip/presentation/bloc/pay_slip_bloc.dart';
import 'package:linchpin/features/pay_slip/presentation/detail_pay_slip_screen.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';
import 'package:linchpin/gen/assets.gen.dart';

class PaySlipScreen extends StatefulWidget {
  const PaySlipScreen({super.key});

  @override
  State<PaySlipScreen> createState() => _PaySlipScreenState();
}

class _PaySlipScreenState extends State<PaySlipScreen> {
  @override
  void initState() {
    BlocProvider.of<PaySlipBloc>(context).add(PayslipListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(
        context,
        true,
        () => Navigator.pop(context),
      ),
      body: BlocBuilder<PaySlipBloc, PaySlipState>(
        buildWhen: (previous, current) {
          if (current is PayslipListCompletedState ||
              current is PayslipListErrorState ||
              current is PayslipListLoadingState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is PayslipListLoadingState) {
            return LoadingWidget();
          } else if (state is PayslipListErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<PaySlipBloc>(context).add(PayslipListEvent());
              },
            );
          } else if (state is PayslipListCompletedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    BigDemiBold('گزارشات مالی'),
                    SizedBox(height: 24),
                    state.payslipListEntity.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.payslipListEntity.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = state.payslipListEntity[index];

                              // تاریخ واریز
                              final paymentDate =
                                  DateTime.parse(data.paymentDate.toString())
                                      .toPersianNumericDate();

                              // ماه و سال در عنوان
                              final persianDate =
                                  DateTime.parse(data.date.toString())
                                      .toPersianMonthYear();

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPaySlipScreen(
                                        id: data.id.toString(),
                                        title: 'فیش حقوق $persianDate',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff828282)
                                            .withValues(alpha: .04),
                                        blurRadius: 30,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          NormalMedium('فیش حقوق $persianDate'),
                                          SizedBox(height: 12),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Assets.icons.calendar.svg(
                                                height: 24,
                                                colorFilter: ColorFilter.mode(
                                                    Color(0xff861C8C),
                                                    BlendMode.srcIn),
                                              ),
                                              SizedBox(width: 4),
                                              NormalRegular(
                                                'تاریخ واریز:',
                                                textColorInLight:
                                                    Color(0xff861C8C),
                                              ),
                                              SizedBox(width: 4),
                                              NormalRegular(
                                                paymentDate,
                                                textColorInLight:
                                                    Color(0xff861C8C),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xffDADADA),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: context.screenHeight / 3.2,
                              ),
                              NormalRegular(
                                'فیش حقوقی برای شما ثبت نشده است.',
                                textColorInLight: Color(0xffCAC4CF),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: NormalMedium("data"));
          }
        },
      ),
    );
  }
}
