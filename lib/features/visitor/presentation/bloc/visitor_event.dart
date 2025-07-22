part of 'visitor_bloc.dart';

sealed class VisitorEvent extends Equatable {
  const VisitorEvent();

  @override
  List<Object> get props => [];
}

class UploadImage extends VisitorEvent {
  final SetLocationEntity? upload;

  const UploadImage({this.upload});
}

class SaveLocationEvent extends VisitorEvent {
  final LatLng? position;
  final FormData? img;

  const SaveLocationEvent({this.position, this.img});

  @override
  List<Object> get props => [position ?? Object()];
}
