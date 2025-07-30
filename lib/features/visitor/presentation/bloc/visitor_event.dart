part of 'visitor_bloc.dart';

sealed class VisitorEvent extends Equatable {
  const VisitorEvent();

  @override
  List<Object> get props => [];
}

class UploadImage extends VisitorEvent {
  final List<String>? filePath;

  const UploadImage(this.filePath);
}

class GetLocation extends VisitorEvent {}

class SetLocationEvent extends VisitorEvent {
  final SetLocationRequest? setLocationRequest;

  const SetLocationEvent({this.setLocationRequest});

  @override
  List<Object> get props => [];
}
