part of 'time_management_bloc.dart';

sealed class TimeManagementState {}

final class DailyLoadingState extends TimeManagementState {}

final class DailyComplitedState extends TimeManagementState {
  final DailyEntity dailyEntity;

  DailyComplitedState(this.dailyEntity);
}

final class DailyErrorState extends TimeManagementState {
  final String errorText;

  DailyErrorState(this.errorText);
}
