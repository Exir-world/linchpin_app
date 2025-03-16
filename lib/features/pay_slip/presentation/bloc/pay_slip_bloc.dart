import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pay_slip_list_entity.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pays_lip_detail_entity.dart';
import 'package:linchpin/features/pay_slip/domain/use_case/pay_slip_usecase.dart';

part 'pay_slip_event.dart';
part 'pay_slip_state.dart';

@injectable
class PaySlipBloc extends Bloc<PaySlipEvent, PaySlipState> {
  final PaySlipUsecase paySlipUsecase;
  PaySlipBloc(this.paySlipUsecase) : super(PaySlipInitial()) {
    on<PayslipListEvent>(_onPayslipListEvent);
    on<PayslipDetailEvent>(_onPayslipDetailEvent);
  }

  void _onPayslipListEvent(
      PayslipListEvent event, Emitter<PaySlipState> emit) async {
    emit(PayslipListLoadingState());

    DataState dataState = await paySlipUsecase.payslipList();

    if (dataState is DataSuccess) {
      emit(PayslipListCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(PayslipListErrorState(dataState.error!));
    }
  }

  void _onPayslipDetailEvent(
      PayslipDetailEvent event, Emitter<PaySlipState> emit) async {
    emit(PayslipDetailLoadingState());

    DataState dataState = await paySlipUsecase.payslipDetail(event.id);

    if (dataState is DataSuccess) {
      emit(PayslipDetailCompletedState(dataState.data));
    }

    if (dataState is DataFailed) {
      emit(PayslipDetailErrorState(dataState.error!));
    }
  }
}
