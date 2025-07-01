part of 'visitor_bloc.dart';

sealed class VisitorEvent extends Equatable {
  const VisitorEvent();

  @override
  List<Object> get props => [];
}

class SaveLocationEvent extends VisitorEvent {
  final LatLng? position;
  final String? img;

  const SaveLocationEvent({this.position, this.img});

  @override
  List<Object> get props => [position ?? Object()];
}
