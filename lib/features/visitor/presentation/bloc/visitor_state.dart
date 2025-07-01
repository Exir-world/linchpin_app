part of 'visitor_bloc.dart';

sealed class VisitorState extends Equatable {
  const VisitorState();

  @override
  List<Object> get props => [];
}

final class VisitorInitial extends VisitorState {}

class SaveLocationLoading extends VisitorState {}

class SaveLocationSuccess extends VisitorState {}

class SaveLocationFailure extends VisitorState {
  final String? error;

  const SaveLocationFailure({this.error});
}
