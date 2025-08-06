import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/time_management/domain/entity/start_end_work_entity.dart';
import 'package:linchpin/features/time_management/domain/repository/time_management_repository.dart';

abstract class StartEndWorkUseCase {
  final TimeManagementRepository timeManagementRepository;

  StartEndWorkUseCase(this.timeManagementRepository);

  // ساعت ورود و خروج
  Future<DataState<StartEndWorkEntity>> startEndWork();
}

@Singleton(as: StartEndWorkUseCase, env: [Env.prod])
class StartEndWorkImpl extends StartEndWorkUseCase {
  StartEndWorkImpl(super.authRepository);

  @override
  Future<DataState<StartEndWorkEntity>> startEndWork() async {
    DataState<StartEndWorkEntity> dataState =
        await timeManagementRepository.startEndWork();
    return dataState;
  }
}
