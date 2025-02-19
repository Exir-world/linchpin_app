import 'package:linchpin_app/core/resources/data_state.dart';
import 'package:linchpin_app/features/growth/domain/entity/user_self_entity.dart';

abstract class GrowthRepository {
  // اطلاعات توسعه فردی
  Future<DataState<UserSelfEntity>> userSelf();

  // ثبت گزارش توسعه فردی
  Future<DataState<UserSelfEntity>> userSelfAdd(
      int improvementId, String description);
}
