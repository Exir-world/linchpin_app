import 'package:linchpin/core/resources/data_state.dart';
import 'package:linchpin/features/growth/domain/entity/sub_items_entity.dart';
import 'package:linchpin/features/growth/domain/entity/user_improvement_entity.dart';
import 'package:linchpin/features/growth/domain/entity/user_self_entity.dart';

abstract class GrowthRepository {
  // // اطلاعات توسعه فردی
  // Future<DataState<UserSelfEntity>> userSelf();

  // اطلاعات توسعه فردی (با تغییرات جدید)
  // جایگزین userSelf
  Future<DataState<UserImprovementEntity>> userImprovementParameters(
      {int? parentId});

  // ثبت گزارش توسعه فردی
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description);

  // لیست امتیازدهی به هر هوش
  Future<DataState<List<SubItemsEntity>>> subitems(int itemId);

  // امتیاز دهی به ساب آیتم های هر هوش
  Future<DataState<List<SubItemsEntity>>> subitemsScore(
      int itemId, int subItemId, int userScore);
}
