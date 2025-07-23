part of 'visitor_bloc.dart';

sealed class VisitorState extends Equatable {
  const VisitorState();

  @override
  List<Object> get props => [];
}

final class VisitorInitial extends VisitorState {}

class SetLocationLoading extends VisitorState {}

class SetLocationSuccess extends VisitorState {}

class UploadImageLoading extends VisitorState {}

class UploadImageSuccess extends VisitorState {}

class SetLocationFailure extends VisitorState {
  final String? error;

  const SetLocationFailure({this.error});
}
