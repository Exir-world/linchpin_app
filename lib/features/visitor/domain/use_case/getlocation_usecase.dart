import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/get_location_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class GetlocationUsecase {
  final VisitorRepository visitorRepository;

  GetlocationUsecase(this.visitorRepository);

  Future<DataState<List<GetLocationEntity>>> getLocation();
}

@Singleton(as: GetlocationUsecase, env: [Env.prod])
class GetLocationUseCaseImpl extends GetlocationUsecase {
  GetLocationUseCaseImpl(super.visitorRepository);

  @override
  Future<DataState<List<GetLocationEntity>>> getLocation() async{
     DataState<List<GetLocationEntity>> dataState =
        await visitorRepository.getLocation();
    return dataState;
  }
  
}