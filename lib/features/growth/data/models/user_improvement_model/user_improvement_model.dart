import 'package:flutter/foundation.dart';
import 'package:linchpin/features/growth/domain/entity/user_improvement_entity.dart';

import 'user_item.dart';

@immutable
class UserImprovementModel extends UserImprovementEntity {
  const UserImprovementModel({super.score, super.scoreIcon, super.userItems});

  factory UserImprovementModel.fromJson(Map<String, dynamic> json) {
    return UserImprovementModel(
      score: json['score'] as int?,
      scoreIcon: json['scoreIcon'] as String?,
      userItems: (json['userItems'] as List<dynamic>?)
          ?.map((e) => UserItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'scoreIcon': scoreIcon,
        'userItems': userItems?.map((e) => e.toJson()).toList(),
      };
}
