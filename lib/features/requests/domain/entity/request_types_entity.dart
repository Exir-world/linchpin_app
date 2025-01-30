import 'package:equatable/equatable.dart';

class RequestTypesEntity extends Equatable {
  final String? requestId;
  final String? title;

  const RequestTypesEntity({this.requestId, this.title});

  @override
  List<Object?> get props => [requestId, title];
}
