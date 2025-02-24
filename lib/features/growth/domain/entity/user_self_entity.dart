import 'package:equatable/equatable.dart';
import 'package:Linchpin/features/growth/data/models/user_self_model/user_item.dart';

class UserSelfEntity extends Equatable {
  final int? score;
  final String? scoreIcon;
  final List<UserItem>? userItems;

  const UserSelfEntity({this.score, this.scoreIcon, this.userItems});

  @override
  List<Object?> get props => [score, scoreIcon, userItems];
}
