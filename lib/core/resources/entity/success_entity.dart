import 'package:equatable/equatable.dart';

class SuccessEntity extends Equatable {
  final String? message;

  const SuccessEntity({this.message});

  @override
  List<Object?> get props => [message];
}
