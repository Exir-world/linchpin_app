part of 'pay_slip_bloc.dart';

sealed class PaySlipState {}

final class PaySlipInitial extends PaySlipState {}

// لیست ماه هایی که فیش حقوق دارند
final class PayslipListLoadingState extends PaySlipState {}

final class PayslipListCompletedState extends PaySlipState {
  final List<PaySlipListEntity> payslipListEntity;

  PayslipListCompletedState(this.payslipListEntity);
}

final class PayslipListErrorState extends PaySlipState {
  final String errorText;

  PayslipListErrorState(this.errorText);
}

// فیش حقوقی برای یک ماه
final class PayslipDetailLoadingState extends PaySlipState {}

final class PayslipDetailCompletedState extends PaySlipState {
  final PayslipDetailEntity payslipDetailEntity;

  PayslipDetailCompletedState(this.payslipDetailEntity);
}

final class PayslipDetailErrorState extends PaySlipState {
  final String errorText;

  PayslipDetailErrorState(this.errorText);
}
