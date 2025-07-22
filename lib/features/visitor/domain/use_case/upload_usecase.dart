import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/set_location_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class UploadUsecase {
  final VisitorRepository visitorRepository;

  UploadUsecase(this.visitorRepository);
  Future<DataState<SetLocationEntity>> upload_image(SetLocationEntity params);
}

@Singleton(as: UploadUsecase, env: [Env.prod])
class UploadImageImpl extends UploadUsecase {
  UploadImageImpl(super.visitorRepository);

  @override
  Future<DataState<SetLocationEntity>> upload_image(
      SetLocationEntity params) async {
    DataState<SetLocationEntity> dataState =
        await visitorRepository.uploadImage(params);
    return dataState;
  }
}
