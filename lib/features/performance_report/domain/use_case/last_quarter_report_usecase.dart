import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/performance_report/domain/entity/months_entity.dart';
import 'package:linchpin_app/features/performance_report/domain/repository/last_quarter_report_repository.dart';

@singleton
class LastQuarterReportUsecase {
  final LastQuarterReportRepository lastQuarterReportRepository;

  LastQuarterReportUsecase(this.lastQuarterReportRepository);

  // گزارش کارکرد 12 ماه گذشته
  Future<DataState<List<MonthsEntity>>> months() async {
    DataState<List<MonthsEntity>> dataState =
        await lastQuarterReportRepository.months();
    return dataState;
  }
}
