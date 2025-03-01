import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/performance_report/domain/entity/months_entity.dart';

abstract class LastQuarterReportRepository {
  // گزارش کارکرد 12 ماه گذشته
  Future<DataState<List<MonthsEntity>>> months();
}
