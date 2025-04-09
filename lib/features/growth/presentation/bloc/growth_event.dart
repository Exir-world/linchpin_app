part of 'growth_bloc.dart';

sealed class GrowthEvent {}

// اطلاعات توسعه فردی
final class UserSelfEvent extends GrowthEvent {}

// ثبت گزارش توسعه فردی
final class UserSelfAddEvent extends GrowthEvent {
  final int improvementId;
  final String description;

  UserSelfAddEvent({required this.improvementId, required this.description});
}

// لیست امتیازدهی به هر هوش
final class SubitemsEvent extends GrowthEvent {
  final int itemId;

  SubitemsEvent(this.itemId);
}

// امتیاز دهی به ساب آیتم های هر هوش
final class SubitemsScoreEvent extends GrowthEvent {
  final int itemId;
  final int subItemId;
  final int userScore;

  SubitemsScoreEvent(this.itemId, this.subItemId, this.userScore);
}
