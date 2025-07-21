import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/performance_report/domain/entity/daily_report_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';
import 'package:linchpin/features/performance_report/domain/entity/report_entity.dart';
import 'package:linchpin/features/performance_report/domain/repository/last_quarter_report_repository.dart';

abstract class LastQuarterReportUsecase {
  final LastQuarterReportRepository lastQuarterReportRepository;

  LastQuarterReportUsecase(this.lastQuarterReportRepository);

  // گزارش کارکرد 12 ماه گذشته
  Future<DataState<List<MonthsEntity>>> months();

  // گزارش کارکرد یک ماه
  Future<DataState<ReportEntity>> report(String startDate, String endDate);

  // گزارش کارکرد یک روز
  Future<DataState<DailyReportEntity>> dailyReport(String date);
}

@Singleton(as: LastQuarterReportUsecase, env: [Env.prod])
class LastQuarterReportUsecaseImpl extends LastQuarterReportUsecase {
  LastQuarterReportUsecaseImpl(super.lastQuarterReportRepository);

  @override
  Future<DataState<List<MonthsEntity>>> months() async {
    DataState<List<MonthsEntity>> dataState =
        await lastQuarterReportRepository.months();
    return dataState;
  }

  @override
  Future<DataState<ReportEntity>> report(
      String startDate, String endDate) async {
    DataState<ReportEntity> dataState =
        await lastQuarterReportRepository.report(startDate, endDate);
    return dataState;
  }

  @override
  Future<DataState<DailyReportEntity>> dailyReport(String date) async {
    DataState<DailyReportEntity> dataState =
        await lastQuarterReportRepository.dailyReport(date);
    return dataState;
  }
}
