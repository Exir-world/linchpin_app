part of 'time_management_bloc.dart';

sealed class TimeManagementEvent {}

final class DailyEvent extends TimeManagementEvent {
  final String actionType;

  DailyEvent({required this.actionType});
}
