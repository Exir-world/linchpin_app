import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linchpin/core/common/custom_text.dart';
import 'package:linchpin/core/customui/error_ui_widget.dart';
import 'package:linchpin/core/customui/loading_widget.dart';
import 'package:linchpin/core/extension/currency_formatter_extension.dart';
import 'package:linchpin/core/extension/date_time_extensions.dart';
import 'package:linchpin/core/extension/time_conversion.dart';
import 'package:linchpin/features/pay_slip/presentation/bloc/pay_slip_bloc.dart';
import 'package:linchpin/features/root/presentation/app_bar_root.dart';

class DetailPaySlipScreen extends StatefulWidget {
  final String id;
  final String title;
  const DetailPaySlipScreen({super.key, required this.id, required this.title});

  @override
  State<DetailPaySlipScreen> createState() => _DetailPaySlipScreenState();
}

class _DetailPaySlipScreenState extends State<DetailPaySlipScreen> {
  @override
  void initState() {
    BlocProvider.of<PaySlipBloc>(context)
        .add(PayslipDetailEvent(id: widget.id));
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
          if (current is PayslipDetailCompletedState ||
              current is PayslipDetailErrorState ||
              current is PayslipDetailLoadingState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is PayslipDetailLoadingState) {
            return LoadingWidget();
          } else if (state is PayslipDetailErrorState) {
            return ErrorUiWidget(
              title: state.errorText,
              onTap: () {
                BlocProvider.of<PaySlipBloc>(context)
                    .add(PayslipDetailEvent(id: widget.id));
              },
            );
          } else if (state is PayslipDetailCompletedState) {
            // تاریخ واریز
            final paymentDate =
                DateTime.parse(state.payslipDetailEntity.paymentDate.toString())
                    .toPersianNumericDate();
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          RowBoxPay(
                            title: 'تاریخ واریز',
                            description: paymentDate,
                          ),
                          SizedBox(height: 28),
                          Container(
                            height: .5,
                            decoration: BoxDecoration(
                              color: Color(0xffE0E0F9),
                            ),
                          ),
                          SizedBox(height: 28),
                          RowBoxPay(
                            title: 'کارکرد استاندارد',
                            description:
                                '${state.payslipDetailEntity.standardWorkDays} روز',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'کارکرد خالص',
                            description:
                                '${state.payslipDetailEntity.netWorkDays} روز',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'کسر کار',
                            description: state.payslipDetailEntity
                                .absentMinutes!.formattedTime,
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'اضافه کار',
                            description: state.payslipDetailEntity
                                .overtimeMinutes!.formattedTime,
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'مرخصی با حقوق',
                            description: state.payslipDetailEntity.leaveMinutes!
                                .formattedTime,
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'ماموریت',
                            description: state.payslipDetailEntity
                                .missionMinutes!.formattedTime,
                          ),
                          SizedBox(height: 28),
                          Container(
                            height: .5,
                            decoration: BoxDecoration(
                              color: Color(0xffE0E0F9),
                            ),
                          ),
                          SizedBox(height: 28),
                          RowBoxPay(
                            title: 'حقوق و دستمزد ماهانه',
                            description:
                                '${state.payslipDetailEntity.baseSalary!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'پایه سنوات',
                            description:
                                '${state.payslipDetailEntity.seniorityPay!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'اضافه کار',
                            description:
                                '${state.payslipDetailEntity.overtimePay!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'حق بیمه',
                            description:
                                '${state.payslipDetailEntity.insuranceFee!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 12),
                          RowBoxPay(
                            title: 'عیدی',
                            description:
                                '${state.payslipDetailEntity.bonus!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 28),
                          Container(
                            height: .5,
                            decoration: BoxDecoration(
                              color: Color(0xffE0E0F9),
                            ),
                          ),
                          SizedBox(height: 28),
                          RowBoxPayBold(
                            title: 'جمع کل',
                            description:
                                '${state.payslipDetailEntity.totalAmount!.toCurrencyFormat()} تومان',
                          ),
                          SizedBox(height: 12),
                          RowBoxPayBold(
                            title: 'خالص دریافتی',
                            description:
                                '${state.payslipDetailEntity.netPayable!.toCurrencyFormat()} تومان',
                          ),
                        ],
                      ),
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

class RowBoxPayBold extends StatelessWidget {
  final String title;
  final String description;
  const RowBoxPayBold({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NormalBold(
          title,
          textColorInLight: Color(0xff861C8C),
        ),
        NormalBold(
          description,
          textColorInLight: Color(0xff861C8C),
        ),
      ],
    );
  }
}

class RowBoxPay extends StatelessWidget {
  final String title;
  final String description;
  const RowBoxPay({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NormalMedium(title),
        NormalMedium(
          description,
          textColorInLight: Color(0xff828282),
        ),
      ],
    );
  }
}
