import 'package:injectable/injectable.dart';
import 'package:linchpin_app/core/locator/di/di.dart';
import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/growth/domain/entity/user_self_entity.dart';
import 'package:linchpin_app/features/growth/domain/repository/growth_repository.dart';

abstract class GrowthUsecase {
  final GrowthRepository growthRepository;

  GrowthUsecase(this.growthRepository);

  // اطلاعات توسعه فردی
  Future<DataState<UserSelfEntity>> userSelf();

  // ثبت گزارش توسعه فردی
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description);
}

@Singleton(as: GrowthUsecase, env: [Env.prod])
class GrowthUsecaseUsecaseImpl extends GrowthUsecase {
  GrowthUsecaseUsecaseImpl(super.growthRepository);

  @override
  Future<DataState<UserSelfEntity>> userSelf() async {
    DataState<UserSelfEntity> dataState = await growthRepository.userSelf();
    return dataState;
  }

  @override
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description) async {
    DataState<UserSelfEntity> dataState =
        await growthRepository.userSelfAdd(improvementId, description);
    return dataState;
  }
}
