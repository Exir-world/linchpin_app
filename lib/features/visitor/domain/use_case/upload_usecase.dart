import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class UploadUsecase {
  final VisitorRepository visitorRepository;

  UploadUsecase(this.visitorRepository);
  Future<DataState<List<String>>> upload_image();
}

@Singleton(as: UploadUsecase, env: [Env.prod])
class UploadImageImpl extends UploadUsecase {
  UploadImageImpl(super.visitorRepository);

  @override
  Future<DataState<List<String>>> upload_image() async {
    DataState<List<String>> dataState = await visitorRepository.uploadImage();
    return dataState;
  }
}
