import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/property/domain/entity/my_properties_entity.dart';

abstract class PropertyRepository {
  Future<DataState<List<MyPropertiesEntity>>> myProperties();
}
