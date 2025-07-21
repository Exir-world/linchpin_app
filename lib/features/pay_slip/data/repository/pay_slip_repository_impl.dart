import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/pay_slip/data/data_source/api_pay_slip.dart';
import 'package:linchpin/features/pay_slip/data/models/pay_slip_list/pay_slip_list_model.dart';
import 'package:linchpin/features/pay_slip/data/models/pays_lip_detail_model.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pay_slip_list_entity.dart';
import 'package:linchpin/features/pay_slip/domain/entity/pays_lip_detail_entity.dart';
import 'package:linchpin/features/pay_slip/domain/repository/pay_slip_repository.dart';

@Singleton(as: PaySlipRepository, env: [Env.prod])
class PaySlipRepositoryImpl extends PaySlipRepository {
  final ApiPaySlip apiPaySlip;

  PaySlipRepositoryImpl(this.apiPaySlip);

  @override
  Future<DataState<List<PaySlipListEntity>>> payslipList() async {
    try {
      Response response = await apiPaySlip.payslipList();
      List<PaySlipListEntity> payslipListEntity = List<PaySlipListEntity>.from(
          response.data.map((model) => PaySlipListModel.fromJson(model)));
      return DataSuccess(payslipListEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<PayslipDetailEntity>> payslipDetail(String id) async {
    try {
      Response response = await apiPaySlip.payslipDetail(id);
      return DataSuccess(PaysLipDetailModel.fromJson(response.data));
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
