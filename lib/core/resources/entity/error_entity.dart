import 'package:equatable/equatable.dart';

class ErrorEntity extends Equatable {
  final int? responseNumber;
  final String? responseName;
  final int? errorNumber;
  final String? errorName;
  final String? message;

  const ErrorEntity({
    this.responseNumber,
    this.responseName,
    this.errorNumber,
    this.errorName,
    this.message,
  });

  @override
  List<Object?> get props =>
      [responseNumber, responseName, errorNumber, errorName, message];
}
