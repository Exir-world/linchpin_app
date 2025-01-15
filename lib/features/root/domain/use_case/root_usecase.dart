import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/root/domain/entity/daily_entity.dart';
import 'package:linchpin_app/features/root/domain/repository/root_repository.dart';

@singleton
class RootUsecase {
  final RootRepository rootRepository;

  RootUsecase(this.rootRepository);

  // اطلاعات صفحه اصلی
  Future<DataState<DailyEntity>> daily() async {
    DataState<DailyEntity> dataState = await rootRepository.daily();
    return dataState;
  }
}
