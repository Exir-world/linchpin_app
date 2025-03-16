part of 'pay_slip_bloc.dart';

sealed class PaySlipEvent {}

// لیست ماه هایی که فیش حقوق دارند
class PayslipListEvent extends PaySlipEvent {}

// فیش حقوقی برای یک ماه
class PayslipDetailEvent extends PaySlipEvent {
  final String id;
  PayslipDetailEvent({required this.id});
}
