import 'package:flutter/foundation.dart';
import 'package:linchpin/features/growth/domain/entity/sub_items_entity.dart';

@immutable
class SubItemsModel extends SubItemsEntity {
  const SubItemsModel({
    super.id,
    super.title,
    super.score,
    super.userScore,
    super.done,
  });

  factory SubItemsModel.fromJson(Map<String, dynamic> json) => SubItemsModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        score: (json['score'] as List?)?.map((e) => e as int).toList(),
        userScore: json['userScore'] as int?,
        done: json['done'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'score': score,
        'userScore': userScore,
        'done': done,
      };
}
