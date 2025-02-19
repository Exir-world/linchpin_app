part of 'growth_bloc.dart';

sealed class GrowthState {}

final class GrowthInitial extends GrowthState {}

// اطلاعات توسعه فردی
final class UserSelfLoadingState extends GrowthState {}

final class UserSelfCompletedState extends GrowthState {
  final UserSelfEntity userSelfEntity;

  UserSelfCompletedState(this.userSelfEntity);
}

final class UserSelfErrorState extends GrowthState {
  final String errorText;

  UserSelfErrorState(this.errorText);
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
