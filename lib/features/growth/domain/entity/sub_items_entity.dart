import 'package:equatable/equatable.dart';

class SubItemsEntity extends Equatable {
  final int? id;
  final String? title;
  final List<int>? score;
  final int? userScore;
  final bool? done;

  const SubItemsEntity(
      {this.id, this.title, this.score, this.userScore, this.done});

  @override
  List<Object?> get props => [id, title, score, userScore, done];
}
