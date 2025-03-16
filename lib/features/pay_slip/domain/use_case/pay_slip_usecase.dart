import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pay_slip_list_entity.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pays_lip_detail_entity.dart';
import 'package:linchpin/features/pay_slip/domain/repository/pay_slip_repository.dart';

abstract class PaySlipUsecase {
  final PaySlipRepository paySlipRepository;

  PaySlipUsecase(this.paySlipRepository);

  // لیست ماه هایی که فیش حقوق دارند
  Future<DataState<List<PaySlipListEntity>>> payslipList();

  // فیش حقوقی برای یک ماه
  Future<DataState<PayslipDetailEntity>> payslipDetail(String id);
}

@Singleton(as: PaySlipUsecase, env: [Env.prod])
class AuthUsecaseImpl extends PaySlipUsecase {
  AuthUsecaseImpl(super.authRepository);
  @override
  Future<DataState<List<PaySlipListEntity>>> payslipList() async {
    DataState<List<PaySlipListEntity>> dataState =
        await paySlipRepository.payslipList();
    return dataState;
  }

  @override
  Future<DataState<PayslipDetailEntity>> payslipDetail(String id) async {
    DataState<PayslipDetailEntity> dataState =
        await paySlipRepository.payslipDetail(id);
    return dataState;
  }
}
