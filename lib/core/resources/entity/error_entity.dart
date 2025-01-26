import 'package:equatable/equatable.dart';

class ErrorEntity extends Equatable {
  final int? statusCode;
  final String? message;

  const ErrorEntity({
    this.statusCode,
    this.message,
  });

  @override
  List<Object?> get props => [statusCode, message];
}
