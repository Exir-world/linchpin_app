import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

@Singleton(as: VisitorRepository, env: [Env.prod])
class VisitorRepositoryImpl extends VisitorRepository {
  @override
  Future<DataState<bool>> myVisitor() async {
    // TODO: implement myVisitor
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<String>>> uploadImage() async {
    // TODO: implement uploadImage
    throw UnimplementedError();
  }
}
