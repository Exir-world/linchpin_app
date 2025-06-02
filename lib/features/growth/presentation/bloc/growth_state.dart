part of 'growth_bloc.dart';

sealed class GrowthState {}

final class GrowthInitial extends GrowthState {}

// // اطلاعات توسعه فردی
// final class UserSelfLoadingState extends GrowthState {}

// final class UserSelfCompletedState extends GrowthState {
//   final UserSelfEntity userSelfEntity;

//   UserSelfCompletedState(this.userSelfEntity);
// }

// final class UserSelfErrorState extends GrowthState {
//   final String errorText;

//   UserSelfErrorState(this.errorText);
// }

// اطلاعات توسعه فردی (با تغییرات جدید)
// جایگزین userSelf
final class UserImprovementLoadingState extends GrowthState {}

final class UserImprovementCompletedState extends GrowthState {
  final UserImprovementEntity userImprovementEntity;

  UserImprovementCompletedState(this.userImprovementEntity);
}

final class UserImprovementErrorState extends GrowthState {
  final String errorText;

  UserImprovementErrorState(this.errorText);
}

// ثبت گزارش توسعه فردی
final class UserSelfAddLoadingState extends GrowthState {}

final class UserSelfAddCompletedState extends GrowthState {
  final UserSelfEntity userSelfEntity;

  UserSelfAddCompletedState(this.userSelfEntity);
}

final class UserSelfAddErrorState extends GrowthState {
  final String errorText;

  UserSelfAddErrorState(this.errorText);
}

// لیست امتیازدهی به هر هوش
final class SubitemsLoadingState extends GrowthState {}

final class SubitemsCompletedState extends GrowthState {
  final UserImprovementEntity userImprovementEntity;

  SubitemsCompletedState(this.userImprovementEntity);
}

final class SubitemsErrorState extends GrowthState {
  final String errorText;

  SubitemsErrorState(this.errorText);
}

// امتیاز دهی به ساب آیتم های هر هوش
final class SubitemsScoreLoadingState extends GrowthState {}

final class SubitemsScoreCompletedState extends GrowthState {
  final List<SubItemsEntity> subItemsEntity;

  SubitemsScoreCompletedState(this.subItemsEntity);
}

final class SubitemsScoreErrorState extends GrowthState {
  final String errorText;

  SubitemsScoreErrorState(this.errorText);
}
