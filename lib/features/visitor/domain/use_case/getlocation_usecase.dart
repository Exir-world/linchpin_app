import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/response/get_location_response.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class GetlocationUsecase {
  final VisitorRepository visitorRepository;

  GetlocationUsecase(this.visitorRepository);

  Future<DataState<List<Items>>> getLocation();
}

@Singleton(as: GetlocationUsecase, env: [Env.prod])
class GetLocationUseCaseImpl extends GetlocationUsecase {
  GetLocationUseCaseImpl(super.visitorRepository);

  @override
  Future<DataState<List<Items>>> getLocation() async {
    DataState<List<Items>> dataState = await visitorRepository.getLocation();
    return dataState;
  }
}
