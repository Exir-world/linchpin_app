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
