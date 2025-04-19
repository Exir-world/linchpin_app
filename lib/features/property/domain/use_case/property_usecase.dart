import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/property/domain/entity/my_properties_entity.dart';
import 'package:linchpin/features/property/domain/repository/property_repository.dart';

abstract class PropertyUsecase {
  final PropertyRepository propertyRepository;

  PropertyUsecase(this.propertyRepository);
  Future<DataState<List<MyPropertiesEntity>>> myProperties();
}

@Singleton(as: PropertyUsecase, env: [Env.prod])
class PropertyUsecaseImpl extends PropertyUsecase {
  PropertyUsecaseImpl(super.propertyRepository);

  @override
  Future<DataState<List<MyPropertiesEntity>>> myProperties() async {
    DataState<List<MyPropertiesEntity>> dataState =
        await propertyRepository.myProperties();
    return dataState;
  }
}
