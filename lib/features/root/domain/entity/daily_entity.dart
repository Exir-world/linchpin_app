import 'package:equatable/equatable.dart';
import 'package:linchpin_app/features/root/data/models/daily_model/data.dart';

class DailyEntity extends Equatable {
  final int? statusCode;
  final String? message;
  final Data? data;

  const DailyEntity({this.statusCode, this.message, this.data});

  @override
  List<Object?> get props => [statusCode, message, data];
}
