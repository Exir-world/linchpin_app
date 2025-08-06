import 'package:equatable/equatable.dart';

class StartEndWorkEntity extends Equatable {
  final String? startTime;
  final String? endTime;

  const StartEndWorkEntity({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}
