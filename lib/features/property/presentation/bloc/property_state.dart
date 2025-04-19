part of 'property_bloc.dart';

sealed class PropertyState {}

final class PropertyInitial extends PropertyState {}

// فیش حقوقی برای یک ماه
final class MyPropertyLoadingState extends PropertyState {}

final class MyPropertyCompletedState extends PropertyState {
  final List<MyPropertiesEntity> myPropertiesEntity;

  MyPropertyCompletedState(this.myPropertiesEntity);
}

final class MyPropertyErrorState extends PropertyState {
  final String errorText;

  MyPropertyErrorState(this.errorText);
}
