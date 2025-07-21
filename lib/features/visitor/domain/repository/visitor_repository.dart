import 'package:linchpin/core/resources/data_state.dart';

abstract class VisitorRepository {
  Future<DataState<bool>> myVisitor();
  Future<DataState<List<String>>> uploadImage();
}
