import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:Linchpin/core/locator/di/di.dart';
import 'package:Linchpin/core/resources/data_state.dart';
import 'package:Linchpin/core/utils/handle_error.dart';
import 'package:Linchpin/features/performance_report/data/data_source/api_last_quarter_report.dart';
import 'package:Linchpin/features/performance_report/data/model/months_model/months_model.dart';
import 'package:Linchpin/features/performance_report/domain/entity/months_entity.dart';
import 'package:Linchpin/features/performance_report/domain/repository/last_quarter_report_repository.dart';

@Singleton(as: LastQuarterReportRepository, env: [Env.prod])
class LastQuarterReportRepositoryImpl extends LastQuarterReportRepository {
  final ApiLastQuarterReport apiLastQuarterReport;

  LastQuarterReportRepositoryImpl(this.apiLastQuarterReport);
  @override
  Future<DataState<List<MonthsEntity>>> months() async {
    try {
      Response response = await apiLastQuarterReport.months();
      List<MonthsEntity> monthsEntity = List<MonthsEntity>.from(
          response.data.map((model) => MonthsModel.fromJson(model)));
      return DataSuccess(monthsEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
