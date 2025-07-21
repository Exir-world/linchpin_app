import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/core/utils/handle_error.dart';
import 'package:linchpin/features/performance_report/data/data_source/api_last_quarter_report.dart';
import 'package:linchpin/features/performance_report/data/model/daily_report_model/daily_report_model.dart';
import 'package:linchpin/features/performance_report/data/model/months_model/months_model.dart';
import 'package:linchpin/features/performance_report/data/model/report_model/report_model.dart';
import 'package:linchpin/features/performance_report/domain/entity/daily_report_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/report_entity.dart';
import 'package:linchpin/features/performance_report/domain/repository/last_quarter_report_repository.dart';

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

  @override
  Future<DataState<ReportEntity>> report(
      String startDate, String endDate) async {
    try {
      Response response = await apiLastQuarterReport.report(startDate, endDate);
      ReportEntity reportEntity = ReportModel.fromJson(response.data);
      return DataSuccess(reportEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }

  @override
  Future<DataState<DailyReportEntity>> dailyReport(String date) async {
    try {
      Response response = await apiLastQuarterReport.dailyReport(date);
      DailyReportEntity reportEntity = DailyReportModel.fromJson(response.data);
      return DataSuccess(reportEntity);
    } on DioException catch (e) {
      return await handleError(e);
    }
  }
}
