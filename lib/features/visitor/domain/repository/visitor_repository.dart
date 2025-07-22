import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';

abstract class VisitorRepository {
  Future<DataState<bool>> myVisitor();
  Future<DataState<SetLocationEntity>> uploadImage(SetLocationEntity params);
}
