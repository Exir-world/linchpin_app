import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/data/models/request/set_location_request.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';

abstract class VisitorRepository {
  Future<DataState<bool>> myVisitor();
  Future<DataState<SetLocationEntity>> setLocation(SetLocationRequest params);
}
