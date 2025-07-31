import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/entity/upload_image_entity.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';

abstract class UploadImageUsecase {
  final VisitorRepository visitorRepository;

  UploadImageUsecase(this.visitorRepository);
  Future<DataState<List<UploadImageEntity>>> uploadImage(FormData? files);
}

@Singleton(as: UploadImageUsecase, env: [Env.prod])
class UploadImageIpml extends UploadImageUsecase {
  UploadImageIpml(super.visitorRepository);

  @override
  Future<DataState<List<UploadImageEntity>>> uploadImage(
    FormData? files,
  ) async {
    DataState<List<UploadImageEntity>> dataState =
        await visitorRepository.uploadImage(files);
    return dataState;
  }
}
