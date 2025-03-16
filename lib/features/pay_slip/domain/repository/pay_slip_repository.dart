import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pay_slip_list_entity.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pays_lip_detail_entity.dart';

abstract class PaySlipRepository {
  // لیست ماه هایی که فیش حقوق دارند
  Future<DataState<List<PaySlipListEntity>>> payslipList();

  // فیش حقوقی برای یک ماه
  Future<DataState<PayslipDetailEntity>> payslipDetail(String id);
}
