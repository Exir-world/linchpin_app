import 'package:equatable/equatable.dart';
import 'package:linchpin/features/growth/data/models/user_improvement_model/user_item.dart';

class UserImprovementEntity extends Equatable {
  final int? score;
  final String? scoreIcon;
  final List<UserItem>? userItems;

  const UserImprovementEntity({this.score, this.scoreIcon, this.userItems});

  @override
  List<Object?> get props => [score, scoreIcon, userItems];
}
