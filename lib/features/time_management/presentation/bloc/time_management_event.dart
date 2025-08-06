part of 'time_management_bloc.dart';

sealed class TimeManagementEvent {}

final class DailyEvent extends TimeManagementEvent {
  final String actionType;
  final double lat;
  final double lng;

  DailyEvent({required this.actionType, required this.lat, required this.lng});
}

final class StartEndWorkEvent extends TimeManagementEvent {}
