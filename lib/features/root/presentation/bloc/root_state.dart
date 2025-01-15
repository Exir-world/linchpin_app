part of 'root_bloc.dart';

sealed class RootState {}

final class RootInitial extends RootState {}

final class DailyLoadingState extends RootState {}

final class DailyComplitedState extends RootState {
  final DailyEntity dailyEntity;

  DailyComplitedState(this.dailyEntity);
}

final class DailyErrorState extends RootState {
  final String errorText;

  DailyErrorState(this.errorText);
}
