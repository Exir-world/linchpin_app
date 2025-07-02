import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/visitor/domain/repository/visitor_repository.dart';
import 'package:linchpin/features/visitor/presentation/bloc/visitor_bloc.dart';

abstract class UploadUsecase {
  final VisitorRepository visitorRepository;

  UploadUsecase(this.visitorRepository);
}

@Singleton(as: UploadImage, env: [Env.prod])
class UploadImageImpl extends UploadUsecase {
  UploadImageImpl(super.visitorRepository);

  @override
  Future<DataState<List<String>>> uploadImage() async {
    DataState<List<String>> dataState = await visitorRepository.uploadImage();
    return dataState;
  }
}
