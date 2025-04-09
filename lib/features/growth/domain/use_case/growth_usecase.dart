import 'package:injectable/injectable.dart';
import 'package:linchpin/core/locator/di/di.dart';
import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/growth/domain/entity/sub_items_entity.dart';
import 'package:linchpin/features/growth/domain/entity/user_self_entity.dart';
import 'package:linchpin/features/growth/domain/repository/growth_repository.dart';

abstract class GrowthUsecase {
  final GrowthRepository growthRepository;

  GrowthUsecase(this.growthRepository);

  // اطلاعات توسعه فردی
  Future<DataState<UserSelfEntity>> userSelf();

  // ثبت گزارش توسعه فردی
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description);

  // لیست امتیازدهی به هر هوش
  Future<DataState<List<SubItemsEntity>>> subitems(int itemId);

// امتیاز دهی به ساب آیتم های هر هوش
  Future<DataState<List<SubItemsEntity>>> subitemsScore(
      int itemId, int subItemId, int userScore);
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

  @override
  Future<DataState<List<SubItemsEntity>>> subitems(int itemId) async {
    DataState<List<SubItemsEntity>> dataState =
        await growthRepository.subitems(itemId);
    return dataState;
  }

  @override
  Future<DataState<List<SubItemsEntity>>> subitemsScore(
      int itemId, int subItemId, int userScore) async {
    DataState<List<SubItemsEntity>> dataState =
        await growthRepository.subitemsScore(itemId, subItemId, userScore);
    return dataState;
  }
}
