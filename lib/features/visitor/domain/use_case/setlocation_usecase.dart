import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class SetLocationUseCase {
  final VisitorRepository visitorRepository;

  SetLocationUseCase(this.visitorRepository);
  Future<DataState<SetLocationEntity>> setLocation(SetLocationRequest params);
}

@Singleton(as: SetLocationUseCase, env: [Env.prod])
class SetLocationImpl extends SetLocationUseCase {
  SetLocationImpl(super.visitorRepository);

  @override
  Future<DataState<SetLocationEntity>> setLocation(
      SetLocationRequest params) async {
    DataState<SetLocationEntity> dataState =
        await visitorRepository.setLocation(params);
    return dataState;
  }
}
